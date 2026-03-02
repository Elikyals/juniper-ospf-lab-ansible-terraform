# Bridges

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr11" {
  node_name = var.proxmox_node
  name      = "vmbr11"
  comment   = "TF: vsrx-tf-1 to vsrx-tf-2 link"
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr12" {
  node_name = var.proxmox_node
  name      = "vmbr12"
  comment   = "TF: vsrx-tf-2 to vsrx-tf-3 link"
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr13" {
  node_name = var.proxmox_node
  name      = "vmbr13"
  comment   = "TF: vsrx-tf-1 to vsrx-tf-3 link"
}

# vSRX VMs

locals {
  vsrx_vms = {
    "vsrx-tf-1" = {
      vm_id    = 211
      vmbr_ge0 = "vmbr11"
      vmbr_ge1 = "vmbr13"
    }
    "vsrx-tf-2" = {
      vm_id    = 212
      vmbr_ge0 = "vmbr11"
      vmbr_ge1 = "vmbr12"
    }
    "vsrx-tf-3" = {
      vm_id    = 213
      vmbr_ge0 = "vmbr12"
      vmbr_ge1 = "vmbr13"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vsrx" {
  for_each  = local.vsrx_vms
  name      = each.key
  node_name = var.proxmox_node
  vm_id     = each.value.vm_id

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    file_id = "local:iso/vsrx.img"
    file_format  = "raw"
    interface    = "virtio0"
    size         = 19
  }

  # fxp0 - management
  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }

  # ge-0/0/0
  network_device {
    bridge   = each.value.vmbr_ge0
    model    = "virtio"
    firewall = false
  }

  # ge-0/0/1
  network_device {
    bridge   = each.value.vmbr_ge1
    model    = "virtio"
    firewall = false
  }

  serial_device {
    device = "socket"
  }

  boot_order = ["virtio0"]
  on_boot    = false

  depends_on = [
    proxmox_virtual_environment_network_linux_bridge.vmbr11,
    proxmox_virtual_environment_network_linux_bridge.vmbr12,
    proxmox_virtual_environment_network_linux_bridge.vmbr13,
  ]
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = file("${path.module}/inventory.tpl")
  filename = "${path.module}/../ansible/inventory/hosts-tf.ini"
}