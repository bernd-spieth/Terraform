# Subnets
resource "azurerm_subnet" "subnet-gateway" {
  name                 = "GatewaySubnet" # The name of the subnet that contains a VPN gateway needs to be named GatewaySubnet
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "subnet-dmz-public" {
  name                 = "snet-dmz-public-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "subnet-dmz-private" {
  name                 = "snet-dmz-private-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.2.0/24"]
}

resource "azurerm_subnet" "subnet-vdi" {
  name                 = "snet-vdi-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.5.0/24"]
}

resource "azurerm_subnet" "subnet-adds" {
  name                 = "snet-ds-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.6.0/24"]
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "AzureBastionSubnet" # The name of the subnet that contains a bastion host needs to be named AzureBastionSubnet
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.3.0/24"]
}
