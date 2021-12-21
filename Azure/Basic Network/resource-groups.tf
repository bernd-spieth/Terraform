# Resource group
resource "azurerm_resource_group" "resourcegroup" {
  name     = "rg-${var.customerName}-${var.location}-001"
  location = var.location
  # Merge the common tags with tags defined on this resource
  tags = merge(
    local.commonTags,
    {
      Description = "This resource group contains all Azure resources of the customer"
    }
  )
}
