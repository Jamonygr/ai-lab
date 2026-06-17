resource "azurerm_ai_foundry" "lab" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  friendly_name           = var.friendly_name
  description             = var.description
  storage_account_id      = var.storage_account_id
  key_vault_id            = var.key_vault_id
  application_insights_id = var.application_insights_id
  public_network_access   = var.public_network_access_enabled ? "Enabled" : "Disabled"
  tags                    = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "lab" {
  name               = var.project_name
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.lab.id
  friendly_name      = var.project_friendly_name
  description        = var.project_description
  tags               = var.tags

  identity {
    type = "SystemAssigned"
  }
}
