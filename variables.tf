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

### Virtual Machine ###
variable "vm_size" {
  type = string
}

variable "vm_username" {
  type = string
}

variable "vm_public_key_path" {
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

variable "keyvault_sku_name" {
  type = string
}

variable "keyvault_key_type" {
  type = string
}

variable "keyvault_key_size" {
  type = number
}
