{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "statusbay.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "statusbay.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "statusbay.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{/* Required labels */}}
{{- define "statusbay.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "statusbay.name" . }}"
{{- end -}}


{{/* matchLabels */}}
{{- define "statusbay.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "statusbay.name" . }}"
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "statusbay.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "statusbay.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/* Database variables */}}
{{- define "statusbay.database" -}}
  {{- printf "%s-database" (include "statusbay.fullname" .) -}}
{{- end -}}

{{- define "statusbay.database.host" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- template "statusbay.database" . }}
  {{- else -}}
    {{- .Values.database.host -}}
  {{- end -}}
{{- end -}}

{{- define "statusbay.database.port" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "3306" -}}
  {{- else -}}
    {{- .Values.database.port -}}
  {{- end -}}
{{- end -}}

{{- define "statusbay.database.username" -}}
{{- .Values.database.username -}}
{{- end -}}

{{- define "statusbay.database.rawPassword" -}}
{{- .Values.database.password -}}
{{- end -}}

{{- define "statusbay.database.schema" -}}
{{- .Values.database.schema -}}
{{- end -}}


{{/*
Inject environment vars in the format key:value, if populated
*/}}
{{- define "statusbay.environmentVars" -}}
{{- if .environmentVars -}}
{{- range $key, $value := .environmentVars }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}
{{- end -}}
