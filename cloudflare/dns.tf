provider "cloudflare" {
  use_org_from_zone = "${var.cluster_domain}"
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "etcd" {
  count = "${len(var.master_ips_private)}"

  domain = "${var.cluster_domain}"
  name = "etcd-1"
  value = "${element(var.master_ips_private, count.index)}"

  type = "A"
  ttl = 1
}

resource "cloudflare_record" "k8s" {
  count = "${len(var.master_ips)}"

  domain = "${var.cluster_domain}"
  name = "k8s-1"
  value = "${element(var.master_ips, count.index)}"

  type = "A"
  ttl = 1
}

output "etcd_hostname" {
  value = "etcd.${var.cluster_domain}"
}

output "api_server_hostname" {
  value = "k8s.${var.cluster_domain}"
}
