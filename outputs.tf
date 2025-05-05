output "peering" {
  value       = azurerm_virtual_network_peering.vnet_peering
  description = <<DESCRIPTION
  * `name` - (Required) The name of this virtual network peering.
  * `virtual_network_id` - (Required) The resource ID of the virtual network.  In addition to the Arguments listed above - the following Attributes are exported:
  * `id` - The ID of the virtual network peering.
  * `allow_forwarded_traffic` - Controls if forwarded traffic from VMs in the remote virtual network is allowed.
  * `allow_gateway_transit` - Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.
  * `allow_virtual_network_access` - Controls if the traffic from the local virtual network can reach the remote virtual network.
  * `only_ipv6_peering_enabled` - Specifies whether only IPv6 address space is peered for Subnet peering.
  * `peer_complete_virtual_networks_enabled` - Specifies whether complete Virtual Network address space is peered.
  * `remote_virtual_network_id` - The full Azure resource ID of the remote virtual network.
  * `use_remote_gateways` - Controls if remote gateways can be used on the local virtual network.

Example output:
```
output "name" {
  value = module.module_name.peering.name
}
```
DESCRIPTION
}
