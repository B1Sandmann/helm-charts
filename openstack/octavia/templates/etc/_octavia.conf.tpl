[DEFAULT]
# Print debugging output (set logging level to DEBUG instead of default WARNING level).
debug = True

# AMQP Transport URL
{{ include "ini_sections.default_transport_url" . }}

[api_settings]
bind_host = 0.0.0.0
bind_port = {{.Values.global.octavia_port_internal | default 9876}}

# How should authentication be handled (keystone, noauth)
auth_strategy = keystone

# Dictionary of enabled provider driver names and descriptions
enabled_provider_drivers = {{ .Values.providers }}

# Default provider driver
default_provider_driver = {{ .Values.default_provider | default "noop_driver" }}

[controller_worker]
worker = {{ .Values.worker | default 1 }}
amphora_driver = {{ .Values.amphora_driver  | default "amphora_noop_driver" }}
compute_driver = {{ .Values.compute_driver  | default "compute_noop_driver" }}
network_driver = {{ .Values.network_driver  | default "network_noop_driver" }}

[database]
connection = {{ include "db_url_mysql" . }}

[oslo_messaging]
# Topic (i.e. Queue) Name
topic = f5_prov

[keystone_authtoken]
auth_type = v3password
auth_version = v3
auth_interface = internal
www_authenticate_uri = https://{{include "keystone_api_endpoint_host_public" .}}/v3
auth_url = {{.Values.global.keystone_api_endpoint_protocol_internal | default "http"}}://{{include "keystone_api_endpoint_host_internal" .}}:{{ .Values.global.keystone_api_port_internal | default 5000}}/v3
username = {{ .Release.Name }}{{ .Values.global.user_suffix }}
password = {{ .Values.global.octavia_service_password | default (tuple . .Release.Name | include "identity.password_for_user") | replace "$" "$$" }}
user_domain_id = default
project_name = service
project_domain_id = default
region_name = {{.Values.global.region}}
memcached_servers = {{ .Chart.Name }}-memcached.{{ include "svc_fqdn" . }}:{{ .Values.memcached.memcached.port | default 11211 }}
service_token_roles_required = True
token_cache_time = 600
include_service_catalog = false

{{- include "ini_sections.cache" . }}
