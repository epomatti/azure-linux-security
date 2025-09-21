output "vm_public_ip_address" {
  value = module.vm.public_ip_address
}

output "vm_ssh_connect_command" {
  value = "ssh -i .keys/azure ${var.vm_username}@${module.vm.public_ip_address}"
}
