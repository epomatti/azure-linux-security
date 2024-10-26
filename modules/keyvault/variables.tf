variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "keyvault_purge_protection_enabled" {
  type = bool
}

variable "keyvault_sku_name" {
  type = string
}

variable "keyvault_key_type" {
  type = string
}

variable "keyvault_key_size" {
  type = number
}

variable "allowed_source_address_prefixes" {
  type = list(string)
}
