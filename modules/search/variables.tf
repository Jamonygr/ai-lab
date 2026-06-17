variable "name" {
  description = "Azure AI Search service name."
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

variable "sku" {
  description = "Azure AI Search SKU."
  type        = string
}

variable "semantic_search_sku" {
  description = "Semantic ranker SKU. Use an empty string to leave semantic ranking disabled for the beginner free tier."
  type        = string
  default     = ""
}

variable "public_network_access_enabled" {
  description = "Allow public network access for beginner local Search exercises."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
