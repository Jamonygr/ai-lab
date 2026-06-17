variable "virtual_network_name" {
  description = "Virtual network name for private endpoint exercises."
  type        = string
}

variable "subnet_name" {
  description = "Subnet name for private endpoints."
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

variable "address_space" {
  description = "Virtual network address space."
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Private endpoint subnet address prefixes."
  type        = list(string)
}

variable "private_endpoint_targets" {
  description = "Private endpoint targets keyed by short target name."
  type = map(object({
    resource_id           = string
    subresource_names     = list(string)
    private_dns_zone_name = string
  }))
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
