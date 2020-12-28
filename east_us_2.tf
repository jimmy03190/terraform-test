# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = ">=2.40.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "resource_group_name"
  location = "East US 2"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "eu2-vnet-deployment"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    GISPeering = "online"
  }
}

# Create subnet for this virtual network
resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create route table
resource "azurerm_route_table" "example" {
  name                          = "route_table_name"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = false

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.141.11.200"
  }

  route {
    name                   = "route2"
    address_prefix         = "150.70.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.141.11.200"
  }
}

# Associate subnet with route table
resource "azurerm_subnet_route_table_association" "default" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
}

# Assign Network Contributor role for peering registration
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_virtual_network.example.id
  role_definition_name = "Network Contributor"
  principal_id         = "55768254-98fb-4052-b874-4413bd25608f"
}