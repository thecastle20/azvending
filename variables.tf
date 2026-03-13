# ─────────────────────────────────────────────────────────────────────────────
# variables.tf
# Input variable definitions for the ALZ Subscription Vending module.
# Values are supplied at runtime by the GitHub Actions pipeline via -var flags.
# ─────────────────────────────────────────────────────────────────────────────

variable "subscription_alias" {
  description = "The alias and display name for the new subscription."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]{1,62}[a-z0-9]$", var.subscription_alias))
    error_message = "Subscription alias must be lowercase letters, numbers and hyphens only (2–64 chars)."
  }
}

variable "billing_scope" {
  description = "Full Azure billing scope path under which the subscription will be created."
  type        = string

  validation {
    condition     = startswith(var.billing_scope, "/providers/Microsoft.Billing")
    error_message = "billing_scope must begin with /providers/Microsoft.Billing."
  }
}

variable "management_group_id" {
  description = "The ID of the management group to place the subscription into."
  type        = string
}

variable "location" {
  description = "Primary Azure region for subscription metadata and default resource groups."
  type        = string

  validation {
    condition = contains([
      "australiaeast",
      "australiasoutheast",
      "newzealandnorth"
    ], var.location)
    error_message = "location must be one of: australiaeast, australiasoutheast, newzealandnorth."
  }
}

variable "subscription_workload" {
  description = "Azure subscription workload type. DevTest subscriptions receive discounted rates."
  type        = string
  default     = "Production"

  validation {
    condition     = contains(["Production", "DevTest"], var.subscription_workload)
    error_message = "subscription_workload must be either Production or DevTest."
  }
}
