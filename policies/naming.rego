package terraform.naming

deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    name := object.get(resource.change.after, "name", "")
    name != ""
    contains(name, " ")
    msg := sprintf("Resource '%s' name '%s' must not contain spaces", [resource.address, name])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_search_service"
    resource.change.actions[_] == "create"
    resource.change.after.sku != "free"
    msg := sprintf("Search service '%s' should use the free SKU in the beginner lab", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_static_web_app"
    resource.change.actions[_] == "create"
    resource.change.after.sku_tier != "Free"
    msg := sprintf("Static Web App '%s' is not using the Free tier", [resource.address])
}

warn[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_search_service"
    resource.change.actions[_] == "create"
    resource.change.after.semantic_search_sku != null
    resource.change.after.sku == "free"
    msg := sprintf("Search service '%s' enables semantic search settings on the free SKU; confirm support before apply", [resource.address])
}
