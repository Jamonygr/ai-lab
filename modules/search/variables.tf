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

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}

