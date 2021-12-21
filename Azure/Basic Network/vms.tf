# Virtual machines
# Create Windows vm as firewall (I know, it is just a test :-))
resource "azurerm_windows_virtual_machine" "vm-firewall" {
  name                = "S20-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_A4_v2"
  admin_username      = var.windowsAdmin
  admin_password      = var.windowsAdminPassword
  network_interface_ids = [
    azurerm_network_interface.nic-firewall-subnet-dmz.id,
    azurerm_network_interface.nic-firewall-subnet-vdi.id,
    azurerm_network_interface.nic-firewall-subnet-ds.id
  ]

  os_disk {
    name                 = "S20-001-osdisk-1-${var.customerName}-${var.location}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "The virtual machine used as test router / gateway between the different subnets"
    }
  )
}
