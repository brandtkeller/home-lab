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