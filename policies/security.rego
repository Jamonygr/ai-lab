package terraform.security

deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    value := object.get(resource.change.after, "local_auth_enabled", null)
    value == false
    contains(resource.type, "cognitive")
    msg := sprintf("Cognitive resource '%s' disables local auth; beginner scripts expect key auth", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_key_vault"
    resource.change.actions[_] == "create"
    resource.change.after.purge_protection_enabled == false
    msg := sprintf("Key Vault '%s' has purge protection disabled for lab teardown convenience", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    tags := object.get(resource.change.after, "tags", {})
    not tags["Owner"]
    msg := sprintf("Resource '%s' must include an Owner tag", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_key_vault_secret"
    resource.change.actions[_] == "create"
    msg := sprintf("Key Vault secret '%s' stores service credentials; confirm RBAC and cleanup expectations", [resource.address])
}
