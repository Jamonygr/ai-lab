output "hub_id" {
  description = "Foundry hub ID."
  value       = azurerm_ai_foundry.lab.id
}

output "hub_name" {
  description = "Foundry hub name."
  value       = azurerm_ai_foundry.lab.name
}

output "hub_discovery_url" {
  description = "Foundry hub discovery URL."
  value       = azurerm_ai_foundry.lab.discovery_url
}

output "project_id" {
  description = "Foundry project resource ID."
  value       = azurerm_ai_foundry_project.lab.id
}

output "project_name" {
  description = "Foundry project name."
  value       = azurerm_ai_foundry_project.lab.name
}

output "project_guid" {
  description = "Foundry project GUID."
  value       = azurerm_ai_foundry_project.lab.project_id
}
