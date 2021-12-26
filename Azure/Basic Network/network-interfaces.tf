# Network interfaces for the firewall (defined after this section). 
# It is not allowed to place a network interface card in the gateway subnet so we only
# place the nics in the othwe subnets

# First the network interface in the public DMZ subnet
resource "azurerm_network_interface" "nic-firewall-subnet-dmz-public" {
  name                = "S20-001-nic-${var.customerName}-${var.location}-subnet-dmz-public"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  # Enable ip forwarding because it is the network interface card of a firewall
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "S20-001-ip-nic-${var.customerName}-${var.location}-subnet-dmz-public"
    subnet_id                     = azurerm_subnet.subnet-dmz-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.254"
    public_ip_address_id          = azurerm_public_ip.pip-nic-vm-S20-001.id
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the public DMZ subnet. This network interface card has also a public ip to connect to the vm over the internet"
    }
  )
}

# Second the network interface in the private DMZ subnet
resource "azurerm_network_interface" "nic-firewall-subnet-dmz-private" {
  name                = "S20-001-nic-${var.customerName}-${var.location}-subnet-dmz-private"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  # Enable ip forwarding because it is the network interface card of a firewall
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "S20-001-ip-${var.customerName}-${var.location}-subnet-dmz-private"
    subnet_id                     = azurerm_subnet.subnet-dmz-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.2.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the private DMZ subnet."
    }
  )
}

# Client interfaces for vm C20-001
resource "azurerm_network_interface" "nic-client-subnet-vdi" {
  name                = "nic-vm-C20-001-${var.customerName}-${var.location}-subnet-vdi"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "C20-001-ip-${var.customerName}-${var.location}-subnet-vdi"
    subnet_id                     = azurerm_subnet.subnet-vdi.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.5.5"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the Virtual Desktop Infrastructure (VDI) subnet"
    }
  )
}

# Client interfaces for vm C20-002
resource "azurerm_network_interface" "nic-client-subnet-adds" {
  name                = "nic-vm-C20-002-${var.customerName}-${var.location}-subnet-adds"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "C20-002-ip-${var.customerName}-${var.location}-subnet-adds"
    subnet_id                     = azurerm_subnet.subnet-adds.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.6.5"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the Active Directory (ADDS) subnet"
    }
  )
}
