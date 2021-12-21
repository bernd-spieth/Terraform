
# Create the route tables for all subnets

# Route table for the gateway subnet
resource "azurerm_route_table" "rt-snet-gateway" {
  name                          = "rt-snet-gateway-${var.customerName}-${var.location}-001"
  location                      = azurerm_resource_group.resourcegroup.location
  resource_group_name           = azurerm_resource_group.resourcegroup.name
  disable_bgp_route_propagation = true

  route {
    name                   = "To-VDI-Subnet"
    address_prefix         = "172.16.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.1.254"
  }

   route {
    name                   = "To-AD-DS-Subnet"
    address_prefix         = "172.16.3.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.1.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The routing table for the gateway subnet that routes all traffic to the other subnets through the firewall interface in the dmz subnet"
    }
  )
}

resource "azurerm_subnet_route_table_association" "rta-snet-gateway" {
  subnet_id      = azurerm_subnet.subnet-gateway.id
  route_table_id = azurerm_route_table.rt-snet-gateway.id
}


# Route table for the vdi subnet
resource "azurerm_route_table" "rt-snet-vdi" {
  name                          = "rt-snet-vdi-${var.customerName}-${var.location}-001"
  location                      = azurerm_resource_group.resourcegroup.location
  resource_group_name           = azurerm_resource_group.resourcegroup.name
  disable_bgp_route_propagation = true

  route {
    name                   = "To-Gateway-Subnet"
    address_prefix         = "172.16.0.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.2.254"
  }

   route {
    name                   = "To-AD-DS-Subnet"
    address_prefix         = "172.16.3.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.2.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The routing table for the vdi subnet that routes all traffic to the other subnets through the firewall interface in the vdi subnet"
    }
  )
}

resource "azurerm_subnet_route_table_association" "rta-snet-vdi" {
  subnet_id      = azurerm_subnet.subnet-vdi.id
  route_table_id = azurerm_route_table.rt-snet-vdi.id
}


# Route table for the ad ds subnet
resource "azurerm_route_table" "rt-snet-adds" {
  name                          = "rt-snet-adds-${var.customerName}-${var.location}-001"
  location                      = azurerm_resource_group.resourcegroup.location
  resource_group_name           = azurerm_resource_group.resourcegroup.name
  disable_bgp_route_propagation = true

  route {
    name                   = "To-Gateway-Subnet"
    address_prefix         = "172.16.0.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.3.254"
  }

  route {
    name                   = "To-VDI-Subnet"
    address_prefix         = "172.16.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.3.254"
  }

  tags = merge(
    local.commonTags,
    {
      Description = "The routing table for the ad ds subnet that routes all traffic to the other subnets through the firewall interface in the ad ds subnet"
    }
  )
}

resource "azurerm_subnet_route_table_association" "rta-snet-adds" {
  subnet_id      = azurerm_subnet.subnet-adds.id
  route_table_id = azurerm_route_table.rt-snet-adds.id
}