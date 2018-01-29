{{- define "share_netapp_conf" -}}
{{- $context := index . 0 -}}
{{- $share := index . 1 -}}
{{- $az := index . 2 -}}
[DEFAULT]
storage_availability_zone = {{$az}}
# The percentage of backend capacity reserved. Default 0 (integer value)
reserved_share_percentage = {{ $share.reserved_share_percentage | default 5 }}

[netapp-multi]
share_backend_name={{$share.backend_name | default "netapp-multi"}}
share_driver=manila.share.drivers.netapp.common.NetAppDriver
driver_handles_share_servers=True
netapp_storage_family=ontap_cluster
netapp_server_hostname={{$share.host}}
netapp_server_port=443
netapp_transport_type=https
netapp_login={{$share.username}}
netapp_password={{$share.password}}
netapp_mtu={{$share.mtu}}

netapp_root_volume_aggregate={{$share.root_volume_aggregate}}
netapp_aggregate_name_search_pattern={{$share.aggregate_search_pattern}}

netapp_vserver_name_template = ma_%s
netapp_lif_name_template = os_%(net_allocation_id)s
netapp_port_name_search_pattern = {{$share.port_search_pattern}}

neutron_physical_net_name={{$share.physical_network}}
network_api_class=manila.network.neutron.neutron_network_plugin.NeutronBindNetworkPlugin
{{- end -}}
