variable "num_master_nodes" {
  default = 3
}

variable "num_worker_nodes" {
  default = 5
}

variable "ssh_fingerprints" {
  default = []

  type = "list"
}

variable "digitalocean_token" {}

variable "worker_config" {}

variable "master_config" {}
