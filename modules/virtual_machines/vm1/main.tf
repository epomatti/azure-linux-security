locals {
  name = "${var.workload}-vm1"
}

resource "azurerm_public_ip" "default" {
  name                = "pip-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "default" {
  name                       = "vm-${local.name}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  size                       = var.size
  admin_username             = var.username
  network_interface_ids      = [azurerm_network_interface.default.id]
  encryption_at_host_enabled = var.encryption_at_host_enabled
  zone                       = var.zone

  vtpm_enabled                                           = true
  secure_boot_enabled                                    = true
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  patch_mode                                             = "AutomaticByPlatform"

  custom_data = filebase64("${path.module}/custom_data/cloud_init.yaml")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                   = "osdisk-linux-${local.name}"
    caching                = "ReadOnly"
    storage_account_type   = "StandardSSD_LRS"
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }
}

resource "azurerm_managed_disk" "data000" {
  name                   = "datadisk-${local.name}-000"
  location               = var.location
  resource_group_name    = var.resource_group_name
  storage_account_type   = "StandardSSD_LRS"
  create_option          = "Empty"
  disk_size_gb           = 4
  disk_encryption_set_id = var.disk_encryption_set_id
  zone                   = var.zone
}

resource "azurerm_managed_disk" "data001" {
  name                   = "datadisk-${local.name}-001"
  location               = var.location
  resource_group_name    = var.resource_group_name
  storage_account_type   = "StandardSSD_LRS"
  create_option          = "Empty"
  disk_size_gb           = 8
  disk_encryption_set_id = var.disk_encryption_set_id
  zone                   = var.zone
}

resource "azurerm_virtual_machine_data_disk_attachment" "data000" {
  managed_disk_id    = azurerm_managed_disk.data000.id
  virtual_machine_id = azurerm_linux_virtual_machine.default.id
  # TODO: What is this
  lun = 0
  # TODO: Need to understand this
  caching = "ReadOnly"
  # TODO: Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS
  write_accelerator_enabled = false
}

resource "azurerm_virtual_machine_data_disk_attachment" "data001" {
  managed_disk_id    = azurerm_managed_disk.data001.id
  virtual_machine_id = azurerm_linux_virtual_machine.default.id

  lun                       = 1
  caching                   = "ReadOnly"
  write_accelerator_enabled = false
}

### Private DNS ###
resource "azurerm_private_dns_a_record" "vm1" {
  name                = "vm1"
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.default.private_ip_address]
}
