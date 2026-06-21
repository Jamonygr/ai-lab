variable "ctx" {
  description = "Lab context used for naming, location, environment, ownership, and tags."
  type = object({
    project     = string
    location    = string
    environment = string
    owner       = string
    tags        = map(string)
  })

  default = {
    project     = "ailab"
    location    = "westeurope"
    environment = "lab"
    owner       = "Your Name"
    tags        = {}
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.ctx.project))
    error_message = "ctx.project must use lowercase letters and numbers only, for example ailab."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.ctx.location))
    error_message = "ctx.location must use Azure's lowercase region name, for example westeurope or eastus2."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.ctx.environment))
    error_message = "ctx.environment must use lowercase letters, numbers, or hyphens."
  }
}

variable "deploy_ai_services" {
  description = "Deploy the main Microsoft Foundry Tools / Azure AI services multi-service account."
  type        = bool
  default     = true
}

variable "deploy_content_safety" {
  description = "Deploy Azure AI Content Safety as a separate beginner exercise service."
  type        = bool
  default     = true
}

variable "deploy_ai_search" {
  description = "Deploy Azure AI Search for optional search and RAG exercises."
  type        = bool
  default     = false
}

variable "deploy_document_intelligence" {
  description = "Deploy Azure AI Document Intelligence for layout, invoice, receipt, and custom extraction exercises."
  type        = bool
  default     = false
}

variable "deploy_azure_openai" {
  description = "Deploy an Azure OpenAI account and one model deployment. Requires quota and regional availability."
  type        = bool
  default     = false
}

variable "deploy_ai_foundry" {
  description = "Deploy an Azure AI Foundry hub and project for agent, evaluation, and observability extension exercises."
  type        = bool
  default     = false
}

variable "deploy_app_hosting" {
  description = "Deploy a free Static Web App placeholder for optional app-hosted demos."
  type        = bool
  default     = false
}

variable "deploy_private_networking" {
  description = "Deploy a private endpoint virtual network and private endpoints for enabled lab services. This is an advanced hardening exercise."
  type        = bool
  default     = false
}

variable "deploy_observability_alerts" {
  description = "Deploy Azure Monitor metric alerts for enabled Azure AI service accounts."
  type        = bool
  default     = false
}

variable "store_service_keys_in_key_vault" {
  description = "Store enabled service keys in Key Vault. Requires the Terraform identity to have Key Vault data-plane secret permissions."
  type        = bool
  default     = false
}

variable "grant_deployer_key_vault_secret_permissions" {
  description = "Grant the current Terraform deployer Key Vault Secrets Officer on the lab Key Vault before writing service keys. Intended for live validation runs."
  type        = bool
  default     = false
}

variable "enable_foundry_project_management" {
  description = "Enable project management on the AIServices account where supported."
  type        = bool
  default     = true
}

variable "enable_public_network_access" {
  description = "Allow public endpoints for beginner local exercises. Disable when adding private networking."
  type        = bool
  default     = true
}

variable "ai_services_sku_name" {
  description = "SKU for the main AIServices account. S0 is pay-as-you-go with no fixed lab VM cost."
  type        = string
  default     = "S0"
}

variable "content_safety_sku_name" {
  description = "SKU for the Content Safety account."
  type        = string
  default     = "S0"
}

variable "ai_search_sku" {
  description = "SKU for Azure AI Search. Keep free for the beginner lab."
  type        = string
  default     = "free"
}

variable "ai_search_semantic_search_sku" {
  description = "Semantic ranker SKU for Azure AI Search. Keep empty for the beginner free tier."
  type        = string
  default     = ""
}

variable "document_intelligence_sku_name" {
  description = "SKU for the optional Document Intelligence account."
  type        = string
  default     = "S0"
}

variable "openai_sku_name" {
  description = "SKU for the Azure OpenAI account."
  type        = string
  default     = "S0"
}

variable "openai_deployment_name" {
  description = "Name of the optional Azure OpenAI model deployment."
  type        = string
  default     = "gpt-4o-mini-lab"
}

variable "openai_model_name" {
  description = "Azure OpenAI model name for the optional deployment."
  type        = string
  default     = "gpt-4o-mini"
}

variable "openai_model_version" {
  description = "Azure OpenAI model version for the optional deployment."
  type        = string
  default     = "2024-07-18"
}

variable "openai_model_capacity" {
  description = "Model deployment capacity for the optional Azure OpenAI deployment."
  type        = number
  default     = 1
}

variable "private_network_address_space" {
  description = "Address space for the optional private endpoint virtual network."
  type        = list(string)
  default     = ["10.42.0.0/16"]
}

variable "private_endpoint_subnet_prefixes" {
  description = "Subnet prefixes for optional private endpoints."
  type        = list(string)
  default     = ["10.42.1.0/24"]
}

variable "observability_total_calls_threshold" {
  description = "Azure Monitor alert threshold for total Azure AI calls over the alert window."
  type        = number
  default     = 100
}
