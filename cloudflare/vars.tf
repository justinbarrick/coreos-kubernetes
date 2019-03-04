variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cluster_domain" {}

variable "master_ips" {
  type = "list"
}

variable "master_ips_private" {
  type = "list"
}
