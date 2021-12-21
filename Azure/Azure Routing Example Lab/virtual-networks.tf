# Virtual network
resource "azurerm_virtual_network" "virtual-network" {
  name                = "vnet-${var.customerName}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  address_space       = ["10.0.0.0/16"]

  tags = merge(
    local.commonTags,
    {
      Description = "The standard virtual network that contains all subnets"
    }
  )
}
