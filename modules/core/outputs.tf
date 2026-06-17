output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.lab.name
}

output "resource_group_id" {
  description = "Resource group ID."
  value       = azurerm_resource_group.lab.id
}

output "location" {
  description = "Resource group location."
  value       = azurerm_resource_group.lab.location
}

output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.lab.name
}

output "storage_account_id" {
  description = "Storage account ID."
  value       = azurerm_storage_account.lab.id
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.lab.name
}

output "key_vault_id" {
  description = "Key Vault ID."
  value       = azurerm_key_vault.lab.id
}

output "log_analytics_workspace_name" {
  description = "Log Analytics workspace name."
  value       = azurerm_log_analytics_workspace.lab.name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  value       = azurerm_log_analytics_workspace.lab.id
}

output "application_insights_connection_string" {
  description = "Application Insights connection string."
  value       = azurerm_application_insights.lab.connection_string
  sensitive   = true
}

