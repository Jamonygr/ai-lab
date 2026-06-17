module "core" {
  source = "./modules/core"

  location                  = var.ctx.location
  tags                      = local.tags
  resource_group_name       = "rg-${local.name_seed}-${random_string.suffix.result}"
  storage_account_name      = substr(replace("${var.ctx.project}${var.ctx.environment}${local.location_short}${random_string.suffix.result}", "-", ""), 0, 24)
  key_vault_name            = substr("kv-${local.name_seed}-${random_string.suffix.result}", 0, 24)
  log_analytics_name        = "log-${local.name_seed}-${random_string.suffix.result}"
  application_insights_name = "appi-${local.name_seed}-${random_string.suffix.result}"
}

module "ai_services" {
  count  = var.deploy_ai_services ? 1 : 0
  source = "./modules/foundry-services"

  name                          = "ais-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  sku_name                      = var.ai_services_sku_name
  tags                          = local.tags
  project_management_enabled    = var.enable_foundry_project_management
  public_network_access_enabled = var.enable_public_network_access
}

module "content_safety" {
  count  = var.deploy_content_safety ? 1 : 0
  source = "./modules/content-safety"

  name                          = "cs-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  sku_name                      = var.content_safety_sku_name
  tags                          = local.tags
  public_network_access_enabled = var.enable_public_network_access
}

module "ai_search" {
  count  = var.deploy_ai_search ? 1 : 0
  source = "./modules/search"

  name                          = substr("srch-${replace(local.name_seed, "-", "")}-${random_string.suffix.result}", 0, 60)
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  sku                           = var.ai_search_sku
  semantic_search_sku           = var.ai_search_semantic_search_sku
  public_network_access_enabled = var.enable_public_network_access
  tags                          = local.tags
}

module "document_intelligence" {
  count  = var.deploy_document_intelligence ? 1 : 0
  source = "./modules/document-intelligence"

  name                          = "di-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  sku_name                      = var.document_intelligence_sku_name
  public_network_access_enabled = var.enable_public_network_access
  tags                          = local.tags
}

module "azure_openai" {
  count  = var.deploy_azure_openai ? 1 : 0
  source = "./modules/openai"

  name                          = "oai-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  sku_name                      = var.openai_sku_name
  tags                          = local.tags
  public_network_access_enabled = var.enable_public_network_access
  deployment_name               = var.openai_deployment_name
  model_name                    = var.openai_model_name
  model_version                 = var.openai_model_version
  model_capacity                = var.openai_model_capacity
}

module "ai_foundry" {
  count  = var.deploy_ai_foundry ? 1 : 0
  source = "./modules/foundry"

  name                          = "fdry-${local.name_seed}-${random_string.suffix.result}"
  friendly_name                 = "AI Lab Foundry"
  description                   = "Optional AI Lab Foundry hub for agent, evaluation, and observability exercises."
  project_name                  = "proj-${local.name_seed}-${random_string.suffix.result}"
  project_friendly_name         = "AI Lab Project"
  project_description           = "Optional AI Lab project for agent and evaluation exercises."
  resource_group_name           = module.core.resource_group_name
  location                      = module.core.location
  storage_account_id            = module.core.storage_account_id
  key_vault_id                  = module.core.key_vault_id
  application_insights_id       = module.core.application_insights_id
  public_network_access_enabled = var.enable_public_network_access
  tags                          = local.tags
}

module "app_hosting" {
  count  = var.deploy_app_hosting ? 1 : 0
  source = "./modules/app-hosting"

  name                = "swa-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name = module.core.resource_group_name
  location            = module.core.location
  tags                = local.tags
}

module "private_networking" {
  count  = var.deploy_private_networking ? 1 : 0
  source = "./modules/private-networking"

  virtual_network_name     = "vnet-${local.name_seed}-${random_string.suffix.result}"
  subnet_name              = "snet-private-endpoints"
  resource_group_name      = module.core.resource_group_name
  location                 = module.core.location
  address_space            = var.private_network_address_space
  subnet_address_prefixes  = var.private_endpoint_subnet_prefixes
  private_endpoint_targets = local.private_endpoint_targets
  tags                     = local.tags
}

module "observability_alerts" {
  count  = var.deploy_observability_alerts ? 1 : 0
  source = "./modules/observability"

  resource_group_name       = module.core.resource_group_name
  cognitive_account_targets = local.cognitive_monitor_targets
  total_calls_threshold     = var.observability_total_calls_threshold
  tags                      = local.tags
}

resource "azurerm_key_vault_secret" "ai_services_key" {
  count        = var.store_service_keys_in_key_vault && var.deploy_ai_services ? 1 : 0
  name         = "ai-services-key"
  value        = module.ai_services[0].primary_access_key
  key_vault_id = module.core.key_vault_id
  content_type = "Azure AI Services primary key"
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "content_safety_key" {
  count        = var.store_service_keys_in_key_vault && var.deploy_content_safety ? 1 : 0
  name         = "content-safety-key"
  value        = module.content_safety[0].primary_access_key
  key_vault_id = module.core.key_vault_id
  content_type = "Content Safety primary key"
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "document_intelligence_key" {
  count        = var.store_service_keys_in_key_vault && var.deploy_document_intelligence ? 1 : 0
  name         = "document-intelligence-key"
  value        = module.document_intelligence[0].primary_access_key
  key_vault_id = module.core.key_vault_id
  content_type = "Document Intelligence primary key"
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ai_search_key" {
  count        = var.store_service_keys_in_key_vault && var.deploy_ai_search ? 1 : 0
  name         = "ai-search-admin-key"
  value        = module.ai_search[0].primary_key
  key_vault_id = module.core.key_vault_id
  content_type = "Azure AI Search admin key"
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "azure_openai_key" {
  count        = var.store_service_keys_in_key_vault && var.deploy_azure_openai ? 1 : 0
  name         = "azure-openai-key"
  value        = module.azure_openai[0].primary_access_key
  key_vault_id = module.core.key_vault_id
  content_type = "Azure OpenAI primary key"
  tags         = local.tags
}
