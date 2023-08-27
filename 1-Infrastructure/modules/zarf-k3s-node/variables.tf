variable "ssh_pub_key_path" {
  default = "~/.ssh/nopass.pub"
}

variable "ssh_priv_key_path" {
  default = "~/.ssh/nopass"
}

variable "password" {
  description = "vm user password"
  type        = string
  sensitive   = true
}

variable "pve_node" {
  description = "proxmox node to use for provisioning VM"
  type        = string
  default     = "pve"
}

variable "name" {
  description = "vm hostname"
  type        = string
}

variable "ip_addr" {
  description = "vm ip address"
  type        = string
}

variable "storage_size" {
  description = "Amount of storage to allocate"
  type        = string
  default     = "60G"
}

variable "storage_type" {
  description = "type of storage to allocate"
  type        = string
  default     = "ssdpool2"
}

variable "memory" {
  description = "amount of memory to allocate"
  type        = number
  default     = 16384
}

variable "cpus" {
  description = "amount of cpus to allocate"
  type        = number
  default     = 4
}

variable "clone_image" {
  description = "image to clone for cloudinit"
  type        = string
  default     = "ubuntu-cloudimg"
}

variable "nameservers" {
  description = "nameservers delimited by a space"
  type        = string
  default     = "8.8.8.8"
}

variable "net_bridge" {
  description = "network bridge"
  type        = string
  default     = "vmbr0"
}

variable "boot" {
  description = "boot on server start"
  type        = bool
  default     = false
}

variable "primary" {
  description = "is this the primary k8s server"
  type        = bool
  default     = false
}

variable "join_server" {
  description = "cluster join url for controlplane"
  type        = string
}