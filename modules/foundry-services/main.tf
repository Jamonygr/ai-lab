resource "azurerm_cognitive_account" "foundry_tools" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "AIServices"
  sku_name                      = var.sku_name
  custom_subdomain_name         = var.name
  local_auth_enabled            = true
  public_network_access_enabled = var.public_network_access_enabled
  project_management_enabled    = var.project_management_enabled
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}

