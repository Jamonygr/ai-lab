output "cognitive_call_volume_alert_ids" {
  description = "Metric alert IDs by target key."
  value       = { for key, alert in azurerm_monitor_metric_alert.cognitive_call_volume : key => alert.id }
}
