# Network interfaces for the firewall (defined after this section). 
# It is not allowed to place a network interface card in the gateway subnet so we only
# place the nics in the othwe subnets

# First the network interface in the DMZ subnet
resource "azurerm_network_interface" "nic-firewall-subnet-dmz" {
  name                = "nic-vm-S20-001-${var.customerName}-${var.location}-subnet-dmz"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  # Enable ip forwarding because it is the network interface card of a firewall
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-nic-vm-S20-001-${var.customerName}-${var.location}-subnet-dmz"
    subnet_id                     = azurerm_subnet.subnet-dmz.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.254"
    public_ip_address_id          = azurerm_public_ip.pip-nic-vm-S20-001.id
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the DMZ subnet. This network interface card has also a public ip to connect to the vm over the internet"
    }
  )
}

# Second the network interface in the VDI subnet
resource "azurerm_network_interface" "nic-firewall-subnet-vdi" {
  name                = "nic-vm-S20-001-${var.customerName}-${var.location}-subnet-vdi"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  # Enable ip forwarding because it is the network interface card of a firewall
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-nic-vm-S20-001-${var.customerName}-${var.location}-subnet-vdi"
    subnet_id                     = azurerm_subnet.subnet-vdi.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.2.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the Virtual Desktop Infrastructure (VDI) subnet"
    }
  )
}


# Third the network interface in the Active Directory subnet
resource "azurerm_network_interface" "nic-firewall-subnet-ds" {
  name                = "nic-vm-S20-001-${var.customerName}-${var.location}-subnet-ds"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  # Enable ip forwarding because it is the network interface card of a firewall
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-nic-vm-S20-001-${var.customerName}-${var.location}-subnet-ds"
    subnet_id                     = azurerm_subnet.subnet-adds.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.3.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the Active Directory subnet"
    }
  )
}
