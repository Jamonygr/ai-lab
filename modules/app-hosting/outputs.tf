output "id" {
  description = "Static Web App ID."
  value       = azurerm_static_web_app.lab.id
}

output "name" {
  description = "Static Web App name."
  value       = azurerm_static_web_app.lab.name
}

output "default_host_name" {
  description = "Static Web App default hostname."
  value       = azurerm_static_web_app.lab.default_host_name
}

