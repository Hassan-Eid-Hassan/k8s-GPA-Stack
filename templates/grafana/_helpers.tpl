{{/*
Expand the name of the chart.
*/}}
{{- define "grafana.name" -}}
{{- default "grafana" $.Values.grafana.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "grafana.fullname" -}}
{{- if $.Values.grafana.fullnameOverride }}
{{- $.Values.grafana.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "grafana" $.Values.grafana.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana.chart" -}}
{{- printf "%s-%s" "grafana" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "grafana.labels" -}}
helm.sh/chart: {{ include "grafana.chart" . }}
{{ include "grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: grafana-server
{{- end }}


{{- define "grafana.serviceAccountName" -}}
{{- if $.Values.grafana.serviceAccount.create }}
{{- default (include "grafana.fullname" .) $.Values.grafana.serviceAccount.name }}-sa
{{- else }}
{{- default "default" $.Values.grafana.serviceAccount.name }}
{{- end }}
{{- end }}