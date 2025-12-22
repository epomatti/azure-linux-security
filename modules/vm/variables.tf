variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type = string
}

variable "username" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "encryption_at_host_enabled" {
  type = bool
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "disk_encryption_set_id" {
  type = string
}

variable "keyvault_disk_encryption_enabled" {
  type = bool
}

variable "zone" {
  type = string
}
