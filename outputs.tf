output "resource_group_name" {
  description = "Resource group for the AI Lab."
  value       = module.core.resource_group_name
}

output "key_vault_name" {
  description = "Key Vault created for lab secrets and future exercises."
  value       = module.core.key_vault_name
}

output "storage_account_name" {
  description = "Storage account for exercise data and artifacts."
  value       = module.core.storage_account_name
}

output "log_analytics_workspace_name" {
  description = "Log Analytics workspace for lab monitoring."
  value       = module.core.log_analytics_workspace_name
}

output "application_insights_connection_string" {
  description = "Application Insights connection string for optional app demos."
  value       = module.core.application_insights_connection_string
  sensitive   = true
}

output "ai_services_endpoint" {
  description = "Endpoint for the main Foundry Tools / Azure AI services account."
  value       = try(module.ai_services[0].endpoint, "")
}

output "ai_services_key" {
  description = "Primary key for the main Foundry Tools / Azure AI services account."
  value       = try(module.ai_services[0].primary_access_key, "")
  sensitive   = true
}

output "content_safety_endpoint" {
  description = "Endpoint for Azure AI Content Safety."
  value       = try(module.content_safety[0].endpoint, "")
}

output "content_safety_key" {
  description = "Primary key for Azure AI Content Safety."
  value       = try(module.content_safety[0].primary_access_key, "")
  sensitive   = true
}

output "ai_search_endpoint" {
  description = "Endpoint for optional Azure AI Search."
  value       = try(module.ai_search[0].endpoint, "")
}

output "ai_search_admin_key" {
  description = "Primary admin key for optional Azure AI Search."
  value       = try(module.ai_search[0].primary_key, "")
  sensitive   = true
}

output "azure_openai_endpoint" {
  description = "Endpoint for optional Azure OpenAI."
  value       = try(module.azure_openai[0].endpoint, "")
}

output "azure_openai_key" {
  description = "Primary key for optional Azure OpenAI."
  value       = try(module.azure_openai[0].primary_access_key, "")
  sensitive   = true
}

output "static_web_app_url" {
  description = "Optional Static Web App URL."
  value       = try(module.app_hosting[0].default_host_name, "")
}

output "exercise_environment" {
  description = "Non-secret values to copy into exercises/python/.env."
  value = {
    AZURE_AI_SERVICES_ENDPOINT = try(module.ai_services[0].endpoint, "")
    AZURE_AI_SERVICES_REGION   = var.ctx.location
    CONTENT_SAFETY_ENDPOINT    = try(module.content_safety[0].endpoint, "")
    AI_SEARCH_ENDPOINT         = try(module.ai_search[0].endpoint, "")
    AZURE_OPENAI_ENDPOINT      = try(module.azure_openai[0].endpoint, "")
    AZURE_OPENAI_DEPLOYMENT    = var.openai_deployment_name
    STATIC_WEB_APP_URL         = try(module.app_hosting[0].default_host_name, "")
    RESOURCE_GROUP_NAME        = module.core.resource_group_name
    KEY_VAULT_NAME             = module.core.key_vault_name
    STORAGE_ACCOUNT_NAME       = module.core.storage_account_name
  }
}

