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
