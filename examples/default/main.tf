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
  }
}

# Create VNet Peering between VNet A and VNet B
# This example demonstrates how to create VNet Peering between two VNets in the same subscription.
module "vnet-peering-a-to-b" {
  source                    = "../../"
  name                      = "vnet-a-to-vnet-b"
  resource_group_name       = azurerm_resource_group.vnetrg.name
  virtual_network_name      = module.vnet-a.virtual_network.name
  remote_virtual_network_id = module.vnet-b.virtual_network.id
}

module "vnet-peering-b-to-a" {
  source                    = "../../"
  name                      = "vnet-b-to-vnet-a"
  resource_group_name       = azurerm_resource_group.vnetrg.name
  virtual_network_name      = module.vnet-b.virtual_network.name
  remote_virtual_network_id = module.vnet-a.virtual_network.id
}
