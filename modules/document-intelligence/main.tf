resource "azurerm_cognitive_account" "document_intelligence" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "FormRecognizer"
  sku_name                      = var.sku_name
  custom_subdomain_name         = var.name
  local_auth_enabled            = true
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}
