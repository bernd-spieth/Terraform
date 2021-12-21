
# The puplic ip for the firewall vm
resource "azurerm_public_ip" "pip-nic-vm-S20-001" {
    name          = "nic-vm-S20-001-${var.customerName}-${var.location}-public-ip"
    location      = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name
    allocation_method = "Dynamic"
    sku = "Basic"
}