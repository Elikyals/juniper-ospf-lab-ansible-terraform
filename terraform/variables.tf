variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type = string
  sensitive = true
}

variable "proxmox_node" {
  description = "Proxmox mode name"
  type = string
  default = "pve"
}

variable "proxmox_username" {
  description = "Proxmox SSH username"
  type        = string
  default     = "root"
}

variable "proxmox_address" {
  description = "Proxmox SSH address (Tailscale IP)"
  type        = string
  sensitive   = true
}

variable "vsrx_image_id" {
  description = "Proxmox storage ID for vSRX image"
  type        = string
  default     = "local:iso/vsrx.img"
}