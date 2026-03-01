output "vsrx_vm_ids" {
  description = "VM IDs for all Terraform-managed vSRX routers"
  value = {
    for name, vm in proxmox_virtual_environment_vm.vsrx :
    name => vm.vm_id
  }
}

output "bridges_created" {
  description = "Terraform-managed lab bridges"
  value       = ["vmbr11", "vmbr12", "vmbr13"]
}