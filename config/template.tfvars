# General
project_name                    = "litware"
location                        = "eastus2"
allowed_source_address_prefixes = ["1.2.3.4/32"] # Replace with your IP address
subscription_id                 = ""

# Key Vault
create_keyvault                   = false
keyvault_purge_protection_enabled = false
keyvault_sku_name                 = "premium"
keyvault_key_type                 = "RSA-HSM"
keyvault_key_size                 = 4096

### Virtual Machines
# Key
public_key_path = ".keys/azure.pub"

# VM1
create_vm1                          = false
vm_size                             = "Standard_B2ats_v2"
vm_username                         = "azureuser"
vm_encryption_at_host_enabled       = false
vm_keyvault_disk_encryption_enabled = false
vm_image_publisher                  = "Canonical"
vm_image_offer                      = "ubuntu-22_04-lts"
vm_image_sku                        = "server"
vm_image_version                    = "latest"

# VM2
create_vm2          = true
vm2_size            = "Standard_B2ats_v2"
vm2_username        = "azureuser"
vm2_image_publisher = "SUSE"
vm2_image_offer     = "sles-15-sp7"
vm2_image_sku       = "gen2"
vm2_image_version   = "latest"
