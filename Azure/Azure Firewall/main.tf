locals {
  commonTags = {
    Environment = "${var.environment}"
    Customer    = "${var.customerName}"
    Owner       = "${var.owner}"
  }
}

provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "resourcegroup" {
  name     = "rg-${var.customerName}-${var.location}-001"
  location = var.location
  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "This resource group contains all Azure resources of the customer"
    }
  )
}

# Virtual network
resource "azurerm_virtual_network" "virtual-network" {
  name                = "vnet-${var.customerName}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  address_space       = ["172.16.0.0/12"]
  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "The standard virtual network that contains all subnets"
    }
  )
}

# Subnets
resource "azurerm_subnet" "subnet-gateway" {
  name                 = "GatewaySubnet" # The name of the subnet that contains a VPN gateway needs to be named GatewaySubnet
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "subnet-dmz" {
  name                 = "snet-dmz-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "subnet-ds" {
  name                 = "snet-ds-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.2.0/24"]
}

resource "azurerm_subnet" "subnet-vdi" {
  name                 = "snet-vdi-${var.customerName}-${var.location}-001"
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = ["172.16.3.0/24"]
}

# Public ip for VPN gateway
resource "azurerm_public_ip" "pip-vpn" {
  name                = "pip-vpn-${var.customerName}-${var.location}-001"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  allocation_method = "Dynamic"
}

# VPN gateway
resource "azurerm_virtual_network_gateway" "vpn-gateway" {
  name                = "vpng-${var.customerName}-${var.location}-001"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  type     = "Vpn"
  vpn_type = "PolicyBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-gateway.id
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The VPN gateway for the connection to the on premises network"
    }
  )
}

# Local network gateway

# Contains information about the on premises environment with the name of the gateway to this
# environment and the subnet so data can be routed
resource "azurerm_local_network_gateway" "local-network-gateway" {
  name                = "lgw-${var.customerName}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  gateway_fqdn        = "c9bgf5nobqyjdbpc.myfritz.net"
  address_space       = ["192.168.35.0/24"]
}

# Connection object

# To configure an IPSec Site-to-Site VPN we must provide the VPN Gateway with the local network gateway and
# the connection object (with contains the shared key) so a connection between Azure and the on premises environment 
# can be established  
resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "con-azure-to-${var.customerName}-${var.location}-001"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local-network-gateway.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

# Network interfaces for the firewall (defined after this section). 
# It is not allowed to place a network interface card in the gateway subnet so we only
# place the nics in the othwe subnets

# First the network interface in the dmz subnet
resource "azurerm_network_interface" "nic-sophosxg-subnet-dmz" {
  name                = "nic-sophosxg-${var.customerName}-${var.location}-subnet-dmz"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "ip-sophosxg-${var.customerName}-${var.location}-subnet-dms"
    subnet_id                     = azurerm_subnet.subnet-dmz.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Second the network interface in the VDI subnet
resource "azurerm_network_interface" "nic-sophosxg-subnet-vdi" {
  name                = "nic-sophosxg-${var.customerName}-${var.location}-subnet-vdi"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "ip-sophosxg-${var.customerName}-${var.location}-subnet-vdi"
    subnet_id                     = azurerm_subnet.subnet-vdi.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Third the network interface in the Actve Directory subnet
resource "azurerm_network_interface" "nic-sophosxg-subnet-ds" {
  name                = "nic-sophosxg-${var.customerName}-${var.location}-subnet-ds"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "ip-sophosxg-${var.customerName}-${var.location}-subnet-ds"
    subnet_id                     = azurerm_subnet.subnet-ds.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual machines
# Create Windows vm as firewall (I know, it is just a test :-))
resource "azurerm_windows_virtual_machine" "windows-firewall" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_A4_v2"
  admin_username      = var.windowsAdmin
  admin_password      = var.windowsAdminPassword
  network_interface_ids = [
    azurerm_network_interface.nic-sophosxg-subnet-dmz.id,
    azurerm_network_interface.nic-sophosxg-subnet-vdi.id,
    azurerm_network_interface.nic-sophosxg-subnet-ds.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}