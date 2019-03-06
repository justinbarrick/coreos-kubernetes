variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cluster_domain" {}

variable "master_ips" {
  type = "list"
}

variable "num_master_nodes" {
  default = 3
}
