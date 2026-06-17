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
}

resource "random_string" "suffix" {
  length  = 5
  lower   = true
  numeric = true
  special = false
  upper   = false
}

