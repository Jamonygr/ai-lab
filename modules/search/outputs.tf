output "id" {
  description = "Azure AI Search service ID."
  value       = azurerm_search_service.lab.id
}

output "name" {
  description = "Azure AI Search service name."
  value       = azurerm_search_service.lab.name
}

output "endpoint" {
  description = "Azure AI Search endpoint."
  value       = "https://${azurerm_search_service.lab.name}.search.windows.net"
}

output "primary_key" {
  description = "Azure AI Search primary admin key."
  value       = azurerm_search_service.lab.primary_key
  sensitive   = true
}

