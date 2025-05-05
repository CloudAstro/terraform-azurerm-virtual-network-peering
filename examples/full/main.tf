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
