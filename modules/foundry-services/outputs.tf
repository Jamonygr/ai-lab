output "id" {
  description = "AIServices account ID."
  value       = azurerm_cognitive_account.foundry_tools.id
}

output "name" {
  description = "AIServices account name."
  value       = azurerm_cognitive_account.foundry_tools.name
}

output "endpoint" {
  description = "AIServices account endpoint."
  value       = azurerm_cognitive_account.foundry_tools.endpoint
}

output "primary_access_key" {
  description = "AIServices account primary access key."
  value       = azurerm_cognitive_account.foundry_tools.primary_access_key
  sensitive   = true
}

