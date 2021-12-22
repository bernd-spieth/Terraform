# Virtual client machines

# The test client in the VDI subnet
resource "azurerm_windows_virtual_machine" "vm-client-vdi" {
  name                = "C20-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_A4_v2"
  admin_username      = var.windowsAdmin
  admin_password      = var.windowsAdminPassword
  network_interface_ids = [
    azurerm_network_interface.nic-client-subnet-vdi.id
  ]

  os_disk {
    name                 = "C20-001-osdisk-1-${var.customerName}-${var.location}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-pro"
    version   = "latest"
  }

  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "The virtual machine used as test client"
    }
  )
}


# The test client in the AD DS subnet
resource "azurerm_windows_virtual_machine" "vm-client-adds" {
  name                = "C20-002"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_A4_v2"
  admin_username      = var.windowsAdmin
  admin_password      = var.windowsAdminPassword
  network_interface_ids = [
    azurerm_network_interface.nic-client-subnet-adds.id
  ]

  os_disk {
    name                 = "C20-002-osdisk-1-${var.customerName}-${var.location}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-pro"
    version   = "latest"
  }

  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "The virtual machine used as test client"
    }
  )
}
