output "id" {
  description = "Document Intelligence account ID."
  value       = azurerm_cognitive_account.document_intelligence.id
}

output "name" {
  description = "Document Intelligence account name."
  value       = azurerm_cognitive_account.document_intelligence.name
}

output "endpoint" {
  description = "Document Intelligence endpoint."
  value       = azurerm_cognitive_account.document_intelligence.endpoint
}

output "primary_access_key" {
  description = "Document Intelligence primary access key."
  value       = azurerm_cognitive_account.document_intelligence.primary_access_key
  sensitive   = true
}
