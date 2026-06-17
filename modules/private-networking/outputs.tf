output "virtual_network_id" {
  description = "Private endpoint virtual network ID."
  value       = azurerm_virtual_network.lab.id
}

output "subnet_id" {
  description = "Private endpoint subnet ID."
  value       = azurerm_subnet.private_endpoints.id
}

output "private_endpoint_ids" {
  description = "Private endpoint IDs by target key."
  value       = { for key, endpoint in azurerm_private_endpoint.lab : key => endpoint.id }
}
