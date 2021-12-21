# Subnets

resource "azurerm_subnet" "subnet-public" {
  name                 = "snet-public-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "snet-private-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-dmz" {
  name                 = "snet-dmz-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["10.0.2.0/24"]
}
