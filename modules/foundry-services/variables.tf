variable "name" {
  description = "AIServices account name."
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
  description = "AIServices SKU."
  type        = string
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}

variable "project_management_enabled" {
  description = "Enable project management on the AIServices account where supported."
  type        = bool
}

variable "public_network_access_enabled" {
  description = "Allow public network access."
  type        = bool
}

