output "vm1_public_ip_address" {
  value = module.vm1.public_ip_address
}

output "vm1_ssh_connect_command" {
  value = "ssh -i .keys/azure ${var.vm_username}@${module.vm1.public_ip_address}"
}
