variable "num_master_nodes" {
  default = 3
}

variable "num_worker_nodes" {
  default = 5
}

variable "auth_token" {}

variable "worker_config" {
  default = ""
}

variable "master_config" {
  default = ""
}

variable "ipxe_url" {
  default = ""
}

variable "ssh_public_key" {}
