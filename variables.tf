variable "name" {
  type        = string
  nullable    = false
  description = <<DESCRIPTION
* `name` - (Required) The name of the virtual network peering. Changing this forces a new resource to be created.

Example input:
```
name = vpeering-to-dev
```
DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
  * `resource_group_name` - (Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created.

  Example input:
  ```
  resource_group_name = rg-vnet-hub
  ```
  DESCRIPTION
}

variable "virtual_network_name" {
  type        = string
  description = <<DESCRIPTION
  * `virtual_network_name` - (Required) The name of the virtual network. Changing this forces a new resource to be created.

  Example input:
  ```
  virtual_network_name = vnet-hub
  ```
  DESCRIPTION
}

variable "local_subnet_names" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
  * `local_subnet_names` - (Optional) A list of local Subnet names that are Subnet peered with remote Virtual Network.

  Example input:
  ```
  local_subnet_names = ["subnet1", "subnet2"]
  ```
  DESCRIPTION
}

variable "remote_virtual_network_id" {
  type        = string
  nullable    = false
  description = <<DESCRIPTION
* `remote_virtual_network_id` - (Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created.

Example input:
```
remote_virtual_network_id = azurerm_virtual_network.vnet-b.id
```
DESCRIPTION
}

variable "only_ipv6_peering_enabled" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
  * `only_ipv6_peering_enabled` - (Optional) Specifies whether only IPv6 address space is peered for Subnet peering. Changing this forces a new resource to be created.

  Example input:
  ```
  only_ipv6_peering_enabled = false
  ```
  DESCRIPTION
}

variable "remote_subnet_names" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
* `remote_subnet_names` - (Optional) A list of remote Subnet names from remote Virtual Network that are Subnet peered.

Example input:
```
remote_subnet_names = ["subnet1", "subnet2"]
```
DESCRIPTION
}

variable "peer_complete_virtual_networks_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
  * `peer_complete_virtual_networks_enabled` - (Optional) Specifies whether complete Virtual Network address space is peered. Defaults to `true`. Changing this forces a new resource to be created.

  Example input:
  ```
  peer_complete_virtual_networks_enabled = true
  ```
  DESCRIPTION
}

variable "allow_virtual_network_access" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `allow_virtual_network_access` - (Optional) Controls if the traffic from the local virtual network can reach the remote virtual network. Defaults to `true`.

Example input:
```
allow_virtual_network_access = true
```
DESCRIPTION
}

variable "allow_forwarded_traffic" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
* `allow_forwarded_traffic` - (Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to `false`.

Example input:
```
allow_forwarded_traffic = false
```
DESCRIPTION
}

variable "allow_gateway_transit" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
* `allow_gateway_transit` - (Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Defaults to `false`.

Example input:
```
allow_gateway_transit = false
```
DESCRIPTION
}

variable "use_remote_gateways" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
* `use_remote_gateways` - (Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to `true`, and `allow_gateway_transit` on the remote peering is also `true`, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway. Defaults to `false`.

-> **Note:** `use_remote_gateways` must be set to `false` if using Global Virtual Network Peerings.

Example input:
```
use_remote_gateways = false
```
DESCRIPTION
}

variable "triggers" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  * `triggers` - (Optional) A mapping of key values pairs that can be used to sync network routes from the remote virtual network to the local virtual network. See [the trigger example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#example-usage-triggers) for an example on how to set it up.

  Example input:
  ```
  triggers = {
    remote_address_space  = join(",", azurerm_virtual_network.example-2.address_space)
    trigger1              = "value1"
    trigger2              = "value2"
  }
  ```
  DESCRIPTION
}


variable "timeouts" {
  type = object({
    create = optional(string, "30")
    update = optional(string, "30")
    read   = optional(string, "5")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
  * `create` - (Defaults to 30 minutes) Used when creating the Virtual Network Peering.
  * `update` - (Defaults to 30 minutes) Used when updating the Virtual Network Peering.
  * `read` - (Defaults to 5 minutes) Used when retrieving the Virtual Network Peering.
  * `delete` - (Defaults to 30 minutes) Used when deleting the Virtual Network Peering.## NoteVirtual Network peerings cannot be created, updated or deleted concurrently.
DESCRIPTION
}
