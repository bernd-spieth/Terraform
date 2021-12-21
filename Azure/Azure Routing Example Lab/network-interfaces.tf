# Network interfaces for the firewall
# It is not allowed to place a network interface card in the gateway subnet so we only
# place the nics in the othwe subnets

# First the network interface in the DMZ subnet
resource "azurerm_network_interface" "nic-firewall-subnet-dmz" {
  name                = "nic-vm-S30-001-${var.customerName}-${var.location}-subnet-dmz"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "ip-nic-vm-S30-001-${var.customerName}-${var.location}-subnet-dmz"
    subnet_id                     = azurerm_subnet.subnet-dmz.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The network interface for the connection to the DMZ subnet"
    }
  )
}
