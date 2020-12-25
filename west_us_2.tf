# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.40.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "resource_group_name"
  location = "West US 2"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "wu2-vnet-deployment"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    GISPeering = "online"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_route_table" "example" {
  name                          = "route_table_name"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = false

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.140.11.200"
  }

  route {
    name                   = "route2"
    address_prefix         = "150.70.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.140.11.200"
  }
}

resource "azurerm_subnet_route_table_association" "default" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
}