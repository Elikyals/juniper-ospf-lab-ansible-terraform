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

output "management_ips" {
  description = "Management IPs for all vSRX routers"
  value = {
    "vsrx-tf-1" = "10.0.0.211"
    "vsrx-tf-2" = "10.0.0.212"
    "vsrx-tf-3" = "10.0.0.213"
  }
}