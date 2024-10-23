output "id" {
  value = azurerm_key_vault.default.id
}

output "keyvault_uri" {
  value = azurerm_key_vault.default.vault_uri
}

output "keyvault_resource_id" {
  value = azurerm_key_vault.default.id
}

output "keyvault_key_id" {
  value = azurerm_key_vault_key.default.id
}

output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.default.id

  depends_on = [
    azurerm_key_vault_access_policy.disk_set,
    azurerm_key_vault_access_policy.current
  ]
}
