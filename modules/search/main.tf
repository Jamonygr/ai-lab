resource "azurerm_search_service" "lab" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  replica_count                 = 1
  partition_count               = 1
  semantic_search_sku           = var.semantic_search_sku != "" ? var.semantic_search_sku : null
  public_network_access_enabled = var.public_network_access_enabled
  local_authentication_enabled  = true
  tags                          = var.tags
}
