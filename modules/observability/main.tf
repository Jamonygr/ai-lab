resource "azurerm_monitor_metric_alert" "cognitive_call_volume" {
  for_each            = var.cognitive_account_targets
  name                = "alert-${each.key}-calls"
  resource_group_name = var.resource_group_name
  scopes              = [each.value.resource_id]
  description         = "Lab alert for unusually high Azure AI call volume on ${each.key}."
  enabled             = true
  severity            = 3
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace       = "Microsoft.CognitiveServices/accounts"
    metric_name            = "TotalCalls"
    aggregation            = "Total"
    operator               = "GreaterThan"
    threshold              = var.total_calls_threshold
    skip_metric_validation = true
  }
}
