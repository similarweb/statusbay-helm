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
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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

{{- define "statusbay.annotations" -}}
statusbay.io/application-name: "statusbay-application"
statusbay.io/progress-deadline-seconds: "300"
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

{{/* Redis variables */}}
{{- define "statusbay.redis" -}}
  {{- printf "%s-redis" (include "statusbay.fullname" .) -}}
{{- end -}}

{{- define "statusbay.redis.host" -}}
  {{- if eq .Values.redis.type "internal" -}}
    {{- template "statusbay.redis" . }}
  {{- else -}}
    {{- .Values.redis.host -}}
  {{- end -}}
{{- end -}}

{{- define "statusbay.redis.port" -}}
  {{- if eq .Values.redis.type "internal" -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.redis.port -}}
  {{- end -}}
{{- end -}}

{{- define "statusbay.redis.rawPassword" -}}
{{- .Values.redis.password -}}
{{- end -}}

{{- define "statusbay.redis.db" -}}
{{- .Values.redis.db -}}
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
