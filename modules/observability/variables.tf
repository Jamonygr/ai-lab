variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "cognitive_account_targets" {
  description = "Cognitive account targets to monitor."
  type = map(object({
    resource_id = string
  }))
}

variable "total_calls_threshold" {
  description = "Total calls threshold over the alert window."
  type        = number
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
