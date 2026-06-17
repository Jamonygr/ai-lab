output "id" {
  description = "Azure OpenAI account ID."
  value       = azurerm_cognitive_account.openai.id
}

output "name" {
  description = "Azure OpenAI account name."
  value       = azurerm_cognitive_account.openai.name
}

output "endpoint" {
  description = "Azure OpenAI endpoint."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "deployment_name" {
  description = "Azure OpenAI model deployment name."
  value       = azurerm_cognitive_deployment.chat.name
}

output "primary_access_key" {
  description = "Azure OpenAI primary access key."
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

