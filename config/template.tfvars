# General
project_name                    = "litware"
location                        = "eastus2"
allowed_source_address_prefixes = ["1.2.3.4/32"] # Replace with your IP address
subscription_id                 = ""

# Application VM
vm_size            = "Standard_B2als_v2"
vm_username        = "azureuser"
vm_public_key_path = "keys/temp_rsa.pub"
vm_image_publisher = "Canonical"
vm_image_offer     = "ubuntu-24_04-lts"
vm_image_sku       = "server"
vm_image_version   = "latest"
