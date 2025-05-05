<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# Azure Virtual Network Peering Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)
[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)
[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)
[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/vnet-peering/azurerm/)

This module is designed to manage **Azure Virtual Network (VNet) peerings** between two VNets. It allows fine-grained control over peering settings such as traffic forwarding, gateway transit, and network access, providing secure and scalable network connectivity across VNets.

# Features

- **VNet Peering Management:** Creates and manages peering connections between Azure virtual networks.
- **Access Control:** Supports configuration of virtual network access, forwarded traffic, and gateway transit.
- **IPv6 Peering:** Optionally enables IPv6 peering for dual-stack scenarios.
- **Complete Network Peering:** Allows peering of all subnets and networks across the virtual networks.

# Example Usage

This example demonstrates how to configure a peering between two virtual networks:

```hcl
resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

module "vnet-a" {
  source              = "CloudAstro/virtual-network/azurerm"
  name                = "vnet-a"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = ["10.10.0.0/24"]
  subnet = {
    snet_1 = {
      name             = "subnet-a-1"
      address_prefixes = ["10.10.0.0/25"]
    }
    snet_2 = {
      name             = "subnet-a-2"
      address_prefixes = ["10.10.0.128/25"]
    }
  }
}

module "vnet-b" {
  source              = "CloudAstro/virtual-network/azurerm"
  name                = "vnet-b"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = ["10.11.0.0/24"]
  subnet = {
    snet_1 = {
      name             = "subnet-b-1"
      address_prefixes = ["10.11.0.0/25"]
    }
    snet_2 = {
      name             = "subnet-b-2"
      address_prefixes = ["10.11.0.128/25"]
    }
  }
}


# In case you receive this error during apply:
# SubscriptionNotRegisteredForFeature: Subscription 00000000-0000-0000-0000-000000000000
# is not registered for feature Microsoft.Network/AllowMultiplePeeringLinksBetweenVnets
# required to carry out the requested operation.
#
# Please run the following CLI commands to register the feature:
# az feature register --namespace Microsoft.Network --name AllowMultiplePeeringLinksBetweenVnets
# az provider register --namespace Microsoft.Network

module "vnet-peering-a-to-b" {
  source                                 = "../../"
  name                                   = "vnet-a-to-vnet-b"
  resource_group_name                    = azurerm_resource_group.vnetrg.name
  virtual_network_name                   = module.vnet-a.virtual_network.name
  remote_virtual_network_id              = module.vnet-b.virtual_network.id
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = ["subnet-a-1"]
  remote_subnet_names                    = ["subnet-b-1"]
  allow_virtual_network_access           = true
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  use_remote_gateways                    = false

}

module "vnet-peering-b-to-a" {
  source = "../../"
  providers = {
    azurerm = azurerm.peer
  }
  name                                   = "vnet-b-to-vnet-a"
  resource_group_name                    = azurerm_resource_group.vnetrg.name
  virtual_network_name                   = module.vnet-b.virtual_network.name
  remote_virtual_network_id              = module.vnet-a.virtual_network.id
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = ["subnet-b-1"]
  remote_subnet_names                    = ["subnet-a-1"]
  allow_virtual_network_access           = true
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  use_remote_gateways                    = false
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.vnet_peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Required) The name of the virtual network peering. Changing this forces a new resource to be created.<br/><br/>Example input:<pre>name = vpeering-to-dev</pre> | `string` | n/a | yes |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | * `remote_virtual_network_id` - (Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created.<br/><br/>Example input:<pre>remote_virtual_network_id = azurerm_virtual_network.vnet-b.id</pre> | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | * `resource_group_name` - (Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created.<br/><br/>  Example input:<pre>resource_group_name = rg-vnet-hub</pre> | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | * `virtual_network_name` - (Required) The name of the virtual network. Changing this forces a new resource to be created.<br/><br/>  Example input:<pre>virtual_network_name = vnet-hub</pre> | `string` | n/a | yes |
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | * `allow_forwarded_traffic` - (Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to `false`.<br/><br/>Example input:<pre>allow_forwarded_traffic = false</pre> | `bool` | `false` | no |
| <a name="input_allow_gateway_transit"></a> [allow\_gateway\_transit](#input\_allow\_gateway\_transit) | * `allow_gateway_transit` - (Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Defaults to `false`.<br/><br/>Example input:<pre>allow_gateway_transit = false</pre> | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | * `allow_virtual_network_access` - (Optional) Controls if the traffic from the local virtual network can reach the remote virtual network. Defaults to `true`.<br/><br/>Example input:<pre>allow_virtual_network_access = true</pre> | `bool` | `true` | no |
| <a name="input_local_subnet_names"></a> [local\_subnet\_names](#input\_local\_subnet\_names) | * `local_subnet_names` - (Optional) A list of local Subnet names that are Subnet peered with remote Virtual Network.<br/><br/>  Example input:<pre>local_subnet_names = ["subnet1", "subnet2"]</pre> | `list(string)` | `null` | no |
| <a name="input_only_ipv6_peering_enabled"></a> [only\_ipv6\_peering\_enabled](#input\_only\_ipv6\_peering\_enabled) | * `only_ipv6_peering_enabled` - (Optional) Specifies whether only IPv6 address space is peered for Subnet peering. Changing this forces a new resource to be created.<br/><br/>  Example input:<pre>only_ipv6_peering_enabled = false</pre> | `bool` | `null` | no |
| <a name="input_peer_complete_virtual_networks_enabled"></a> [peer\_complete\_virtual\_networks\_enabled](#input\_peer\_complete\_virtual\_networks\_enabled) | * `peer_complete_virtual_networks_enabled` - (Optional) Specifies whether complete Virtual Network address space is peered. Defaults to `true`. Changing this forces a new resource to be created.<br/><br/>  Example input:<pre>peer_complete_virtual_networks_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_remote_subnet_names"></a> [remote\_subnet\_names](#input\_remote\_subnet\_names) | * `remote_subnet_names` - (Optional) A list of remote Subnet names from remote Virtual Network that are Subnet peered.<br/><br/>Example input:<pre>remote_subnet_names = ["subnet1", "subnet2"]</pre> | `list(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>  * `create` - (Defaults to 30 minutes) Used when creating the Virtual Network Peering.<br/>  * `update` - (Defaults to 30 minutes) Used when updating the Virtual Network Peering.<br/>  * `read` - (Defaults to 5 minutes) Used when retrieving the Virtual Network Peering.<br/>  * `delete` - (Defaults to 30 minutes) Used when deleting the Virtual Network Peering.## NoteVirtual Network peerings cannot be created, updated or deleted concurrently. | <pre>object({<br/>    create = optional(string, "30")<br/>    update = optional(string, "30")<br/>    read   = optional(string, "5")<br/>    delete = optional(string, "30")<br/>  })</pre> | `null` | no |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | * `triggers` - (Optional) A mapping of key values pairs that can be used to sync network routes from the remote virtual network to the local virtual network. See [the trigger example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#example-usage-triggers) for an example on how to set it up.<br/><br/>  Example input:<pre>triggers = {<br/>    remote_address_space  = join(",", azurerm_virtual_network.example-2.address_space)<br/>    trigger1              = "value1"<br/>    trigger2              = "value2"<br/>  }</pre> | `map(string)` | `null` | no |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | * `use_remote_gateways` - (Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to `true`, and `allow_gateway_transit` on the remote peering is also `true`, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway. Defaults to `false`.<br/><br/>-> **Note:** `use_remote_gateways` must be set to `false` if using Global Virtual Network Peerings.<br/><br/>Example input:<pre>use_remote_gateways = false</pre> | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering"></a> [peering](#output\_peering) | * `name` - (Required) The name of this virtual network peering.<br/>  * `virtual_network_id` - (Required) The resource ID of the virtual network.  In addition to the Arguments listed above - the following Attributes are exported:<br/>  * `id` - The ID of the virtual network peering.<br/>  * `allow_forwarded_traffic` - Controls if forwarded traffic from VMs in the remote virtual network is allowed.<br/>  * `allow_gateway_transit` - Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.<br/>  * `allow_virtual_network_access` - Controls if the traffic from the local virtual network can reach the remote virtual network.<br/>  * `only_ipv6_peering_enabled` - Specifies whether only IPv6 address space is peered for Subnet peering.<br/>  * `peer_complete_virtual_networks_enabled` - Specifies whether complete Virtual Network address space is peered.<br/>  * `remote_virtual_network_id` - The full Azure resource ID of the remote virtual network.<br/>  * `use_remote_gateways` - Controls if remote gateways can be used on the local virtual network.<br/><br/>Example output:<pre>output "name" {<br/>  value = module.module_name.peering.name<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information

This module provides a flexible way to manage Azure Virtual Network peerings, enabling secure connectivity between VNets across subscriptions or regions. It supports advanced configuration options such as traffic forwarding, gateway transit, and IPv6 peering, making it suitable for both simple and complex network topologies.

## 📚 Resources

- [Terraform AzureRM Virtual Network Peering Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering)  
- [Azure Virtual Network Peering Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)  
- [Azure Virtual Network Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)  
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## ⚠️ Notes

- Ensure both VNets are in the **same or compatible regions** if required.
- Peering links are **non-transitive** — peered VNets cannot automatically reach other peered VNets.
- Gateway transit and use of remote gateways must be planned carefully to avoid conflicts.
- Review Azure subscription limits for the number of allowed peerings per VNet.

## 🧾 License

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->