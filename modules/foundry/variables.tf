variable "name" {
  description = "Foundry hub name."
  type        = string
}

variable "friendly_name" {
  description = "Foundry hub friendly name."
  type        = string
}

variable "description" {
  description = "Foundry hub description."
  type        = string
}

variable "project_name" {
  description = "Foundry project name."
  type        = string
}

variable "project_friendly_name" {
  description = "Foundry project friendly name."
  type        = string
}

variable "project_description" {
  description = "Foundry project description."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "storage_account_id" {
  description = "Storage account ID used by the Foundry hub."
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID used by the Foundry hub."
  type        = string
}

variable "application_insights_id" {
  description = "Application Insights ID used by the Foundry hub."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Allow public access to the Foundry hub."
  type        = bool
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
