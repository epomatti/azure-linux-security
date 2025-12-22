locals {
  name = "${var.workload}-vm2"
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
  name                  = "vm-${local.name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = var.username
  network_interface_ids = [azurerm_network_interface.default.id]

  # vtpm_enabled                                           = true
  # secure_boot_enabled                                    = true
  # bypass_platform_safety_checks_on_user_schedule_enabled = true
  # patch_mode                                             = "AutomaticByPlatform"

  custom_data = filebase64("${path.module}/custom_data/suse.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "osdisk-linux-${local.name}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
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

resource "azurerm_managed_disk" "data" {
  name                 = "datadrive-${local.name}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  managed_disk_id    = azurerm_managed_disk.data.id
  virtual_machine_id = azurerm_linux_virtual_machine.default.id

  # TODO: What is this
  lun = "0"

  # TODO: Need to understand this
  caching = "ReadOnly"

  # TODO: Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS
  write_accelerator_enabled = false
}
