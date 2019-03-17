resource "etcdiscovery_token" "token" {}

resource "random_string" "kubeadm_token" {
  count = 2

  length = "${count.index == 0 ? 6 : 16}"

  special = false
  upper   = false
  lower   = true
}

locals {
  meta = {
    general = {
      kubeadm_token = "${random_string.kubeadm_token.0.result}.${random_string.kubeadm_token.1.result}"
      ca_key_hash = "${local.ca_key_hash}"
      api_server_hostname = "${var.api_server_hostname}"
      etcd_hostname = "${var.etcd_hostname}"
      etcd_discovery_token = "${etcdiscovery_token.token.id}"
    }
  }
}

data "ignition_file" "metadata" {
  filesystem = "root"
  path = "/etc/ansible/facts.d/node.fact"
  mode = 420
  content {
    content = "${jsonencode(local.meta)}"
  }
}
