resource "azurerm_network_security_group" "nsg-snet-dmz" {
  name                = "nsg-snet-dmz-${var.customerName}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location

  security_rule {
    name                       = "Allow-RDP-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "109.193.231.166"
    destination_address_prefix = "*"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "Network security group for the DMZ subnet"
    }
  )
}

# The next section assigns the network security group to a subnet
resource "azurerm_network_interface_security_group_association" "nsga-dmz" {
  network_interface_id      = azurerm_network_interface.nic-firewall-subnet-dmz.id
  network_security_group_id = azurerm_network_security_group.nsg-snet-dmz.id
}
