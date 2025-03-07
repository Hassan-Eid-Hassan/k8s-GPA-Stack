{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "msteams.name" -}}
{{- default "prometheus-msteams" $.Values.msteams.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified msteams.name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "msteams.fullname" -}}
{{- if $.Values.msteams.fullnameOverride -}}
{{- $.Values.msteams.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "prometheus-msteams" $.Values.msteams.nameOverride -}}
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
{{- define "msteams.chart" -}}
{{- printf "%s-%s" "prometheus-msteams" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1" -}}
{{- else -}}
{{- print "apps/v1beta2" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "msteams.labels" -}}
helm.sh/chart: {{ include "msteams.chart" . }}
{{ include "msteams.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "msteams.selectorLabels" -}}
app: {{ template "msteams.name" . }}
chart: {{ template "msteams.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end }}