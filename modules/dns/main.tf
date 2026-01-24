resource "azurerm_private_dns_zone" "default" {
  name                = "${var.project_name}.internal"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${var.project_name}-private-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = var.vnet_id

  registration_enabled = false
}
