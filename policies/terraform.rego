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

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_cognitive_account"
    resource.change.actions[_] == "create"
    resource.change.after.kind == "FormRecognizer"
    msg := sprintf("Document Intelligence account '%s' is usage-based; confirm the document extraction track is intentional", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_ai_foundry"
    resource.change.actions[_] == "create"
    msg := sprintf("Foundry hub '%s' is an advanced agent/evaluation resource; confirm quota and class scope", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_private_endpoint"
    resource.change.actions[_] == "create"
    msg := sprintf("Private endpoint '%s' changes connectivity and DNS expectations for local exercises", [resource.address])
}

array_contains(arr, elem) {
    arr[_] == elem
}
