output "id" {
  description = "Content Safety account ID."
  value       = azurerm_cognitive_account.content_safety.id
}

output "name" {
  description = "Content Safety account name."
  value       = azurerm_cognitive_account.content_safety.name
}

output "endpoint" {
  description = "Content Safety endpoint."
  value       = azurerm_cognitive_account.content_safety.endpoint
}

output "primary_access_key" {
  description = "Content Safety primary access key."
  value       = azurerm_cognitive_account.content_safety.primary_access_key
  sensitive   = true
}

