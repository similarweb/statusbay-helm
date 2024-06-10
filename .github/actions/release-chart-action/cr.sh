#!/usr/bin/env bash

# Copyright The Helm Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_CHART_RELEASER_VERSION=v1.6.1

show_help() {
  cat <<EOF
Usage: $(basename "$0") <options>

    -h, --help                    Display help
    -v, --version                 The chart-releaser version to use (default: $DEFAULT_CHART_RELEASER_VERSION)"
        --config                  The path to the chart-releaser config file
    -d, --chart-dir              The charts directory (default: charts)
    -o, --owner                   The repo owner
    -r, --repo                    The repo name
EOF
}

main() {
  local version="$DEFAULT_CHART_RELEASER_VERSION"
  local config=
  local chart_dir=.
  local owner=
  local repo=
  local install_dir=

  parse_command_line "$@"

  : "${CR_TOKEN:?Environment variable CR_TOKEN must be set}"

  local repo_root
  repo_root=$(git rev-parse --show-toplevel)
  pushd "$repo_root" >/dev/null

  echo 'Looking up latest tag...'
  local latest_tag
  latest_tag=$(lookup_latest_tag)

  echo 'Checking chart versio'
  pip install yq  >/dev/null 2>&1
  local chart_version
  chart_version="$(yq -r .version Chart.yaml)"

  if [[ "$chart_version" != "v$latest_tag" ]]; then
    echo "Chart version is not equal to latest tag. Proceeding with the release."

    create_new_tag "$chart_version"
    
    install_chart_releaser

    rm -rf .cr-release-packages
    mkdir -p .cr-release-packages

    rm -rf .cr-index
    mkdir -p .cr-index

    package_chart
    release_chart
    update_index
  else
    echo "Nothing to do. Chart version was not updated."
  fi

  echo "chart_version=${latest_tag}" >chart_version.txt

  popd >/dev/null
}

parse_command_line() {
  while :; do
    case "${1:-}" in
    -h | --help)
      show_help
      exit
      ;;
    --config)
      if [[ -n "${2:-}" ]]; then
        config="$2"
        shift
      else
        echo "ERROR: '--config' cannot be empty." >&2
        show_help
        exit 1
      fi
      ;;
    -v | --version)
      if [[ -n "${2:-}" ]]; then
        version="$2"
        shift
      else
        echo "ERROR: '-v|--version' cannot be empty." >&2
        show_help
        exit 1
      fi
      ;;
    -d | --chart-dir)
      if [[ -n "${2:-}" ]]; then
        chart_dir="$2"
        shift
      else
        echo "ERROR: '-d|--chart-dir' cannot be empty." >&2
        show_help
        exit 1
      fi
      ;;
    -o | --owner)
      if [[ -n "${2:-}" ]]; then
        owner="$2"
        shift
      else
        echo "ERROR: '--owner' cannot be empty." >&2
        show_help
        exit 1
      fi
      ;;
    -r | --repo)
      if [[ -n "${2:-}" ]]; then
        repo="$2"
        shift
      else
        echo "ERROR: '--repo' cannot be empty." >&2
        show_help
        exit 1
      fi
      ;;
    -n | --install-dir)
      if [[ -n "${2:-}" ]]; then
        install_dir="$2"
        shift
      fi
      ;;
    *)
      break
      ;;
    esac

    shift
  done

  if [[ -z "$owner" ]]; then
    echo "ERROR: '-o|--owner' is required." >&2
    show_help
    exit 1
  fi

  if [[ -z "$repo" ]]; then
    echo "ERROR: '-r|--repo' is required." >&2
    show_help
    exit 1
  fi

  if [[ -z "$install_dir" ]]; then
    local arch
    arch=$(uname -m)
    install_dir="$RUNNER_TOOL_CACHE/cr/$version/$arch"
  fi
}

create_new_tag() {
  local chart_version="$1"
  local tag="v$chart_version"

  if git rev-parse "$tag" >/dev/null 2>&1; then
    echo "Tag $tag already exists. Skipping tag creation."
  else
    echo "Creating tag $tag..."
    git tag "$tag"
    git push origin "$tag"
  fi
}

install_chart_releaser() {
  if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
    echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
    exit 1
  fi

  if [[ ! -d "$install_dir" ]]; then
    mkdir -p "$install_dir"

    echo "Installing chart-releaser on $install_dir..."
    curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/$version/chart-releaser_${version#v}_linux_amd64.tar.gz"
    tar -xzf cr.tar.gz -C "$install_dir"
    rm -f cr.tar.gz
  fi

  echo 'Adding cr directory to PATH...'
  export PATH="$install_dir:$PATH"
}

lookup_latest_tag() {
  git fetch --tags >/dev/null 2>&1

  if ! git describe --tags --abbrev=0 HEAD~ 2>/dev/null; then
    git rev-list --max-parents=0 --first-parent HEAD
  fi
}

package_chart() {

  local args=("$chart_dir" --package-path .cr-release-packages)
  if [[ -n "$config" ]]; then
    args+=(--config "$config")
  fi

  echo "Packaging chart ..."
  cr package "${args[@]}"
}

release_chart() {
  local args=(-o "$owner" -r "$repo" -c "$(git rev-parse HEAD)")
  if [[ -n "$config" ]]; then
    args+=(--config "$config")
  fi

  args+=(--make-release-latest=true)

  echo 'Releasing chart...'
  cr upload "${args[@]}"
}

update_index() {
  local args=(-o "$owner" -r "$repo" --push)
  if [[ -n "$config" ]]; then
    args+=(--config "$config")
  fi

  echo 'Updating charts repo index...'
  cr index "${args[@]}"
}

main "$@"
