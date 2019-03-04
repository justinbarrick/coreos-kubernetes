module "kubernetes" {
  source = "./kubernetes/"

  kubernetes_version = "v1.13.4"
  crictl_version = "v1.11.1"

  api_server_hostname = "${module.cloudflare.api_server_hostname}"
  etcd_hostname = "${module.cloudflare.etcd_hostname}"
}

module "digitalocean" {
  source = "./digitalocean/"

  num_master_nodes = 3
  num_worker_nodes = 5

  digitalocean_token = "${data.vault_generic_secret.digitalocean.data["token"]}"

  master_config = "${module.kubernetes.master-config}"
  worker_config = "${module.kubernetes.worker-config}"
}

module "cloudflare" {
  source = "./cloudflare/"

  cloudflare_email = "${data.vault_generic_secret.cloudflare.data["email"]}"
  cloudflare_token = "${data.vault_generic_secret.cloudflare.data["token"]}"

  cluster_domain = "codesink.io"
  num_master_nodes = 3

  master_ips = "${module.digitalocean.master-ips}"
  master_ips_private = "${module.digitalocean.master-ips-private}"
}

data "vault_generic_secret" "digitalocean" {
  path = "secret/data/digitalocean"
}

data "vault_generic_secret" "cloudflare" {
  path = "secret/data/cloudflare"
}

output "kubeconfig" {
  value = "${module.kubernetes.kubeconfig}"
  sensitive = true
}
