{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kube-state-metrics.name" -}}
{{- default "kube-state-metrics" $.Values.kubeStateMetrics.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-state-metrics.fullname" -}}
{{- if $.Values.kubeStateMetrics.fullnameOverride -}}
{{- $.Values.kubeStateMetrics.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kube-state-metrics" $.Values.kubeStateMetrics.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kube-state-metrics.serviceAccountName" -}}
{{- if $.Values.kubeStateMetrics.serviceAccount.create -}}
    {{ default (include "kube-state-metrics.fullname" .) $.Values.kubeStateMetrics.serviceAccount.name }}-sa
{{- else -}}
    {{ default "default" $.Values.kubeStateMetrics.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "kube-state-metrics.namespace" -}}
  {{- if $.Values.kubeStateMetrics.namespaceOverride -}}
    {{- $.Values.kubeStateMetrics.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kube-state-metrics.chart" -}}
{{- printf "%s-%s" "kube-state-metrics" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate basic labels
*/}}
{{- define "kube-state-metrics.labels" }}
helm.sh/chart: {{ template "kube-state-metrics.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: metrics
app.kubernetes.io/part-of: {{ template "kube-state-metrics.name" . }}
{{- include "kube-state-metrics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- if $.Values.kubeStateMetrics.customLabels }}
{{ tpl (toYaml $.Values.kubeStateMetrics.customLabels) . }}
{{- end }}
{{- if $.Values.kubeStateMetrics.releaseLabel }}
release: {{ .Release.Name }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kube-state-metrics.selectorLabels" }}
{{- if $.Values.kubeStateMetrics.selectorOverride }}
{{ toYaml $.Values.kubeStateMetrics.selectorOverride }}
{{- else }}
app.kubernetes.io/name: {{ include "kube-state-metrics.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end }}

{{/* Sets default scrape limits for servicemonitor */}}
{{- define "servicemonitor.scrapeLimits" -}}
{{- with .sampleLimit }}
sampleLimit: {{ . }}
{{- end }}
{{- with .targetLimit }}
targetLimit: {{ . }}
{{- end }}
{{- with .labelLimit }}
labelLimit: {{ . }}
{{- end }}
{{- with .labelNameLengthLimit }}
labelNameLengthLimit: {{ . }}
{{- end }}
{{- with .labelValueLengthLimit }}
labelValueLengthLimit: {{ . }}
{{- end }}
{{- end -}}

{{/*
Formats imagePullSecrets. Input is (dict "Values" $.Values.kubeStateMetrics "imagePullSecrets" .{specific imagePullSecrets})
*/}}
{{- define "kube-state-metrics.imagePullSecrets" -}}
{{- range (concat $.Values.kubeStateMetrics.global.imagePullSecrets .imagePullSecrets) }}
  {{- if eq (typeOf .) "map[string]interface {}" }}
- {{ toYaml . | trim }}
  {{- else }}
- name: {{ . }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
The image to use for kube-state-metrics
*/}}
{{- define "kube-state-metrics.image" -}}
{{- if $.Values.kubeStateMetrics.image.sha }}
{{- if $.Values.kubeStateMetrics.global.imageRegistry }}
{{- printf "%s/%s:%s@%s" $.Values.kubeStateMetrics.global.imageRegistry $.Values.kubeStateMetrics.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.image.tag) $.Values.kubeStateMetrics.image.sha }}
{{- else }}
{{- printf "%s/%s:%s@%s" $.Values.kubeStateMetrics.image.registry $.Values.kubeStateMetrics.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.image.tag) $.Values.kubeStateMetrics.image.sha }}
{{- end }}
{{- else }}
{{- if $.Values.kubeStateMetrics.global.imageRegistry }}
{{- printf "%s/%s:%s" $.Values.kubeStateMetrics.global.imageRegistry $.Values.kubeStateMetrics.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.image.tag) }}
{{- else }}
{{- printf "%s/%s:%s" $.Values.kubeStateMetrics.image.registry $.Values.kubeStateMetrics.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.image.tag) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
The image to use for kubeRBACProxy
*/}}
{{- define "kubeRBACProxy.image" -}}
{{- if $.Values.kubeStateMetrics.kubeRBACProxy.image.sha }}
{{- if $.Values.kubeStateMetrics.global.imageRegistry }}
{{- printf "%s/%s:%s@%s" $.Values.kubeStateMetrics.global.imageRegistry $.Values.kubeStateMetrics.kubeRBACProxy.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.kubeRBACProxy.image.tag) $.Values.kubeStateMetrics.kubeRBACProxy.image.sha }}
{{- else }}
{{- printf "%s/%s:%s@%s" $.Values.kubeStateMetrics.kubeRBACProxy.image.registry $.Values.kubeStateMetrics.kubeRBACProxy.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.kubeRBACProxy.image.tag) $.Values.kubeStateMetrics.kubeRBACProxy.image.sha }}
{{- end }}
{{- else }}
{{- if $.Values.kubeStateMetrics.global.imageRegistry }}
{{- printf "%s/%s:%s" $.Values.kubeStateMetrics.global.imageRegistry $.Values.kubeStateMetrics.kubeRBACProxy.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.kubeRBACProxy.image.tag) }}
{{- else }}
{{- printf "%s/%s:%s" $.Values.kubeStateMetrics.kubeRBACProxy.image.registry $.Values.kubeStateMetrics.kubeRBACProxy.image.repository (default (printf "v%s" .Chart.AppVersion) $.Values.kubeStateMetrics.kubeRBACProxy.image.tag) }}
{{- end }}
{{- end }}
{{- end }}
