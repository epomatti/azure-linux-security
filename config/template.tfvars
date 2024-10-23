# General
project_name                    = "litware"
location                        = "eastus2"
allowed_source_address_prefixes = ["1.2.3.4/32"] # Replace with your IP address
subscription_id                 = ""

# Key Vault
keyvault_sku_name = "premium"
keyvault_key_type = "RSA-HSM"
keyvault_key_size = 4096

# Application VM
vm_size                       = "Standard_B2als_v2"
vm_username                   = "azureuser"
vm_public_key_path            = "keys/temp_rsa.pub"
vm_encryption_at_host_enabled = true
vm_image_publisher            = "Canonical"
vm_image_offer                = "ubuntu-24_04-lts"
vm_image_sku                  = "server"
vm_image_version              = "latest"
