terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "random_integer" "generated" {
  min = 000
  max = 999
}

locals {
  affix        = random_integer.generated.result
  workload     = "${var.project_name}${local.affix}"
  default_zone = "1"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}-workload"
  location = var.location
}

module "vnet" {
  source              = "./modules/network/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "nsg" {
  source                          = "./modules/network/nsg"
  workload                        = local.workload
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  compute_subnet_id               = module.vnet.compute_subnet_id
  allowed_source_address_prefixes = var.allowed_source_address_prefixes
}

module "keyvault" {
  source                            = "./modules/keyvault"
  workload                          = local.workload
  resource_group_name               = azurerm_resource_group.default.name
  location                          = azurerm_resource_group.default.location
  keyvault_purge_protection_enabled = var.keyvault_purge_protection_enabled
  keyvault_sku_name                 = var.keyvault_sku_name
  keyvault_key_type                 = var.keyvault_key_type
  keyvault_key_size                 = var.keyvault_key_size
  allowed_source_address_prefixes   = var.allowed_source_address_prefixes
}

module "private_link" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.default.name
  location                    = azurerm_resource_group.default.location
  private_endpoints_subnet_id = module.vnet.private_endpoints_subnet_id
  vnet_id                     = module.vnet.vnet_id
  keyvault_id                 = module.keyvault.id
}

module "vm1" {
  source              = "./modules/virtual_machines/vm1"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  zone            = local.default_zone
  subnet_id       = module.vnet.compute_subnet_id
  size            = var.vm_size
  username        = var.vm_username
  public_key_path = var.public_key_path

  image_publisher = var.vm_image_publisher
  image_offer     = var.vm_image_offer
  image_sku       = var.vm_image_sku
  image_version   = var.vm_image_version

  encryption_at_host_enabled       = var.vm_encryption_at_host_enabled
  keyvault_disk_encryption_enabled = var.vm_keyvault_disk_encryption_enabled
  disk_encryption_set_id           = module.keyvault.disk_encryption_set_id

  depends_on = [module.keyvault, module.private_link]
}

module "vm2" {
  count               = var.create_vm2 ? 1 : 0
  source              = "./modules/virtual_machines/vm2"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  zone            = local.default_zone
  subnet_id       = module.vnet.compute_subnet_id
  size            = var.vm2_size
  username        = var.vm2_username
  public_key_path = var.public_key_path

  image_publisher = var.vm2_image_publisher
  image_offer     = var.vm2_image_offer
  image_sku       = var.vm2_image_sku
  image_version   = var.vm2_image_version
}
