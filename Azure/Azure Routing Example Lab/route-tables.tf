
resource "azurerm_route_table" "rt-snet-public" {
  name                          = "rt-snet-public-${var.customerName}-${var.location}-001"
  location                      = azurerm_resource_group.resourcegroup.location
  resource_group_name           = azurerm_resource_group.resourcegroup.name
  disable_bgp_route_propagation = true

  route {
    name                   = "To-Private-Subnet"
    address_prefix         = "10.0.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.4"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The routing table for the dmz subnet that routes all traffic to the other subnets through the firewall"
    }
  )
}

resource "azurerm_subnet_route_table_association" "rta-snet-public" {
  subnet_id      = azurerm_subnet.subnet-dmz.id
  route_table_id = azurerm_route_table.rt-snet-public.id
}