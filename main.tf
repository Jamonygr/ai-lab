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

  name                = substr("srch-${replace(local.name_seed, "-", "")}-${random_string.suffix.result}", 0, 60)
  resource_group_name = module.core.resource_group_name
  location            = module.core.location
  sku                 = var.ai_search_sku
  tags                = local.tags
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

module "app_hosting" {
  count  = var.deploy_app_hosting ? 1 : 0
  source = "./modules/app-hosting"

  name                = "swa-${local.name_seed}-${random_string.suffix.result}"
  resource_group_name = module.core.resource_group_name
  location            = module.core.location
  tags                = local.tags
}

