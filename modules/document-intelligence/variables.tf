variable "name" {
  description = "Document Intelligence account name."
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
  description = "Document Intelligence SKU."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Allow public endpoints for beginner local exercises."
  type        = bool
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
