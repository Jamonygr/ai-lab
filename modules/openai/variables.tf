variable "name" {
  description = "Azure OpenAI account name."
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

variable "sku_name" {
  description = "Azure OpenAI SKU."
  type        = string
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}

variable "public_network_access_enabled" {
  description = "Allow public network access."
  type        = bool
}

variable "deployment_name" {
  description = "Azure OpenAI model deployment name."
  type        = string
}

variable "model_name" {
  description = "Azure OpenAI model name."
  type        = string
}

variable "model_version" {
  description = "Azure OpenAI model version."
  type        = string
}

variable "model_capacity" {
  description = "Azure OpenAI deployment capacity."
  type        = number
}

