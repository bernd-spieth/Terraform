resource "azurerm_dev_test_global_vm_shutdown_schedule" "shd-S02-001" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm-firewall.id
  location           = azurerm_resource_group.resourcegroup.location

  enabled = true

  daily_recurrence_time = "2100"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shd-C20-001" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm-client-vdi.id
  location           = azurerm_resource_group.resourcegroup.location

  enabled = true

  daily_recurrence_time = "2100"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shd-C20-002" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm-client-adds.id
  location           = azurerm_resource_group.resourcegroup.location

  enabled = true

  daily_recurrence_time = "2100"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}
