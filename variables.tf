# General
variable "project_name" {
  type = string
}

variable "location" {
  type = string
}

variable "allowed_source_address_prefixes" {
  type = list(string)
}

variable "subscription_id" {
  type = string
}

### Keys ###
variable "public_key_path" {
  type = string
}

### Virtual Machine ###
variable "vm_size" {
  type = string
}

variable "vm_username" {
  type = string
}

variable "vm_encryption_at_host_enabled" {
  type = bool
}

variable "vm_image_publisher" {
  type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

variable "vm_image_version" {
  type = string
}

### Key Vault ###
variable "create_keyvault" {
  type = bool
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

### VM2 ###
variable "create_vm2" {
  type = bool
}

variable "vm2_size" {
  type = string
}

variable "vm2_username" {
  type = string
}

variable "vm2_image_publisher" {
  type = string
}

variable "vm2_image_offer" {
  type = string
}

variable "vm2_image_sku" {
  type = string
}

variable "vm2_image_version" {
  type = string
}
