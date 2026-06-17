# OPA policies for Terraform plan JSON.

package terraform

approved_regions := ["westeurope", "northeurope", "eastus", "eastus2", "westus2", "centralus", "canadacentral"]

deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    not resource.change.after.tags
    msg := sprintf("Resource '%s' must have tags", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    location := resource.change.after.location
    location != null
    not array_contains(approved_regions, location)
    msg := sprintf("Resource '%s' is in unapproved region '%s'", [resource.address, location])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_storage_account"
    resource.change.actions[_] == "create"
    resource.change.after.allow_nested_items_to_be_public == true
    msg := sprintf("Storage account '%s' must not allow public blob access", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_cognitive_deployment"
    resource.change.actions[_] == "create"
    msg := sprintf("Azure OpenAI deployment '%s' is cost/quota sensitive; confirm it is intentional", [resource.address])
}

array_contains(arr, elem) {
    arr[_] == elem
}

