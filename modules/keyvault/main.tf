data "azurerm_client_config" "current" {}

locals {
  current_tenant_id = data.azurerm_client_config.current.tenant_id
  current_object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "default" {
  name                = "kv-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = local.current_tenant_id
  sku_name            = var.keyvault_sku_name

  # Must the enabled for disk encryption
  purge_protection_enabled = var.keyvault_purge_protection_enabled

  # These are only required for Azure Disk Encryption (ADE) which are not covered in this project
  enabled_for_disk_encryption = false
}

resource "azurerm_key_vault_key" "default" {
  name         = "encryptkey"
  key_vault_id = azurerm_key_vault.default.id
  key_type     = var.keyvault_key_type
  key_size     = var.keyvault_key_size

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [azurerm_key_vault_access_policy.current]
}

resource "azurerm_disk_encryption_set" "default" {
  name                = "des"
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = azurerm_key_vault_key.default.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "disk_set" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = azurerm_disk_encryption_set.default.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.default.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = local.current_tenant_id
  object_id = local.current_object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
    "Release",
    "Rotate",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
}
