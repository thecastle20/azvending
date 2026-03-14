# ─────────────────────────────────────────────────────────────────────────────
# main.tf
# ─────────────────────────────────────────────────────────────────────────────

terraform {
  required_version = "~> 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
  }

  # Remote state — replace with your storage account details.
  # The storage account must exist before the first terraform init.
  backend "azurerm" {
    resource_group_name  = "nzn-t-storage-rg-01"
    storage_account_name = "castletfstate"
    container_name       = "azvending"
    # Key is set per-run via -backend-config in the pipeline
    # so each subscription gets its own state file.
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

# ─────────────────────────────────────────────────────────────────────────────
# ALZ Subscription Vending Module
# https://github.com/Azure/terraform-azure-avm-ptn-alz-sub-vending/tree/v0.1.1
# ─────────────────────────────────────────────────────────────────────────────

module "sub_vending" {
  source  = "Azure/avm-ptn-alz-sub-vending/azure"
  version = "0.1.1"

  location = var.location

  # Subscription creation
  subscription_alias_enabled = true
  subscription_alias_name    = var.subscription_alias
  subscription_display_name  = var.subscription_alias
  subscription_billing_scope = var.billing_scope
  subscription_workload      = var.subscription_workload

  # Management group placement
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = var.management_group_id
}

# ─────────────────────────────────────────────────────────────────────────────
# Outputs — surfaced in the GitHub Actions run log
# ─────────────────────────────────────────────────────────────────────────────

output "subscription_id" {
  description = "The ID of the newly created subscription."
  value       = module.sub_vending.subscription_id
}

output "subscription_resource_id" {
  description = "The full Azure resource ID of the new subscription."
  value       = module.sub_vending.subscription_resource_id
}
