resource "azurerm_virtual_network" "lab" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "private_endpoints" {
  name                              = var.subnet_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.lab.name
  address_prefixes                  = var.subnet_address_prefixes
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_dns_zone" "lab" {
  for_each            = { for key, target in var.private_endpoint_targets : target.private_dns_zone_name => target... }
  name                = each.key
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "lab" {
  for_each              = azurerm_private_dns_zone.lab
  name                  = "link-${replace(each.key, ".", "-")}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.lab.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "lab" {
  for_each            = var.private_endpoint_targets
  name                = "pe-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = azurerm_subnet.private_endpoints.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.resource_id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.lab[each.value.private_dns_zone_name].id]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.lab]
}
