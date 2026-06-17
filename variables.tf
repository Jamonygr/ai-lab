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

variable "deploy_azure_openai" {
  description = "Deploy an Azure OpenAI account and one model deployment. Requires quota and regional availability."
  type        = bool
  default     = false
}

variable "deploy_app_hosting" {
  description = "Deploy a free Static Web App placeholder for optional app-hosted demos."
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

