provider "cloudflare" {
  use_org_from_zone = "${var.cluster_domain}"
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "etcd" {
  count = "${var.num_master_nodes}"

  domain = "${var.cluster_domain}"
  name = "etcd"
  value = "${element(var.master_ips, count.index)}"

  type = "A"
  ttl = 1
}

resource "cloudflare_record" "k8s" {
  count = "${var.num_master_nodes}"

  domain = "${var.cluster_domain}"
  name = "k8s"
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
