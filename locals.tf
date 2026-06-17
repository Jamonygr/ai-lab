locals {
  location_short_map = {
    westeurope    = "weu"
    northeurope   = "neu"
    eastus        = "eus"
    eastus2       = "eus2"
    westus2       = "wus2"
    centralus     = "cus"
    canadacentral = "cac"
  }

  location_short = lookup(local.location_short_map, var.ctx.location, substr(var.ctx.location, 0, min(6, length(var.ctx.location))))
  name_seed      = lower("${var.ctx.project}-${var.ctx.environment}-${local.location_short}")

  tags = merge(
    {
      Environment = var.ctx.environment
      Project     = "AI Lab"
      Owner       = var.ctx.owner
      ManagedBy   = "Terraform"
      Lab         = "AI Lab"
    },
    var.ctx.tags
  )

  cognitive_monitor_targets = merge(
    var.deploy_ai_services ? {
      ai_services = {
        resource_id = module.ai_services[0].id
      }
    } : {},
    var.deploy_content_safety ? {
      content_safety = {
        resource_id = module.content_safety[0].id
      }
    } : {},
    var.deploy_document_intelligence ? {
      document_intelligence = {
        resource_id = module.document_intelligence[0].id
      }
    } : {},
    var.deploy_azure_openai ? {
      azure_openai = {
        resource_id = module.azure_openai[0].id
      }
    } : {}
  )

  private_endpoint_targets = merge(
    {
      storage_blob = {
        resource_id           = module.core.storage_account_id
        subresource_names     = ["blob"]
        private_dns_zone_name = "privatelink.blob.core.windows.net"
      }
      key_vault = {
        resource_id           = module.core.key_vault_id
        subresource_names     = ["vault"]
        private_dns_zone_name = "privatelink.vaultcore.azure.net"
      }
    },
    var.deploy_ai_services ? {
      ai_services = {
        resource_id           = module.ai_services[0].id
        subresource_names     = ["account"]
        private_dns_zone_name = "privatelink.cognitiveservices.azure.com"
      }
    } : {},
    var.deploy_content_safety ? {
      content_safety = {
        resource_id           = module.content_safety[0].id
        subresource_names     = ["account"]
        private_dns_zone_name = "privatelink.cognitiveservices.azure.com"
      }
    } : {},
    var.deploy_document_intelligence ? {
      document_intelligence = {
        resource_id           = module.document_intelligence[0].id
        subresource_names     = ["account"]
        private_dns_zone_name = "privatelink.cognitiveservices.azure.com"
      }
    } : {},
    var.deploy_azure_openai ? {
      azure_openai = {
        resource_id           = module.azure_openai[0].id
        subresource_names     = ["account"]
        private_dns_zone_name = "privatelink.openai.azure.com"
      }
    } : {},
    var.deploy_ai_search ? {
      ai_search = {
        resource_id           = module.ai_search[0].id
        subresource_names     = ["searchService"]
        private_dns_zone_name = "privatelink.search.windows.net"
      }
    } : {}
  )
}

resource "random_string" "suffix" {
  length  = 5
  lower   = true
  numeric = true
  special = false
  upper   = false
}
