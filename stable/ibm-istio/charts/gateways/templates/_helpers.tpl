{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
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
{{- define "gateway.chart" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gateway.nodeselector" -}}
{{- if contains "icp" .Capabilities.KubeVersion.GitVersion -}}
{{- range $key, $spec := .Values -}}
{{- if and (ne $key "global") (ne $key "enabled") -}}
  {{- if eq $spec.nodeRole "proxy" }}
  proxy: "true"
  {{- end -}}
  {{- if eq $spec.nodeRole "management" }}
  management: "true"
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }}

{{- define "gateway.tolerations" -}}
{{- if contains "icp" .Capabilities.KubeVersion.GitVersion -}}
{{- range $key, $spec := .Values -}}
{{- if and (ne $key "global") (ne $key "enabled") -}}
{{- if or (eq $spec.nodeRole "proxy") (eq $spec.nodeRole "management") }}
- key: "dedicated"
  operator: "Exists"
  effect: "NoSchedule"
- key: CriticalAddonsOnly
  operator: Exists
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }}
