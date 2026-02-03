resource "azurerm_network_security_rule" "allow_rsync_vm1_to_vm2_outbound" {
  name                        = "AllowRsyncVM1toVM2Outbound"
  description                 = "Allows rsync pulling connection from VM1 to VM2 on port 22"
  priority                    = 800
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.vm1_private_ip_address
  destination_address_prefix  = var.vm2_private_ip_address
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "allow_rsync_vm1_to_vm2_inbound" {
  name                        = "AllowRsyncVM1toVM2Inbound"
  description                 = "Allows rsync pulling connection from VM1 to VM2 on port 22"
  priority                    = 800
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.vm1_private_ip_address
  destination_address_prefix  = var.vm2_private_ip_address
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}
