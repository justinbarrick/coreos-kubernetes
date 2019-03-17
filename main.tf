module "kubernetes" {
  source = "./kubernetes/"

  kubernetes_version = "v1.13.4"
  crictl_version = "v1.11.1"

  api_server_hostname = "${module.cloudflare.api_server_hostname}"
  etcd_hostname = "${module.cloudflare.etcd_hostname}"
}

module "cloudflare" {
  source = "./cloudflare/"

  cluster_domain = "codesink.io"
  num_master_nodes = 3

  cloudflare_email = "${data.vault_generic_secret.cloudflare.data["email"]}"
  cloudflare_token = "${data.vault_generic_secret.cloudflare.data["token"]}"

  master_ips = "${module.digitalocean.master-ips}"
}

module "digitalocean" {
  source = "./digitalocean/"

  num_master_nodes = 3
  num_worker_nodes = 5

  ssh_public_keys = [
    "${module.kubernetes.ssh-public-key}"
  ]

  ssh_fingerprints = [
    "2b:07:2e:3e:13:13:c0:9a:c7:4f:71:0e:81:01:a4:4d",
    "c9:eb:65:63:44:bc:ca:85:50:c0:6f:88:6a:03:1e:55"
  ]

  digitalocean_token = "${data.vault_generic_secret.digitalocean.data["token"]}"

  master_config = "${module.kubernetes.master-config}"
  worker_config = "${module.kubernetes.worker-config}"
}

module "packet" {
  source = "./packet/"

  num_master_nodes = 0
  num_worker_nodes = 0

  auth_token = "${data.vault_generic_secret.packet.data["token"]}"
  ssh_public_key = "${file("~/.ssh/id_rsa.pub")}"

  ipxe_url = "${module.matchbox.ipxe-url}"
}

module "matchbox" {
  source = "./matchbox/"

  matchbox_endpoint = "${data.vault_generic_secret.matchbox.data["endpoint"]}"
  matchbox_url = "${data.vault_generic_secret.matchbox.data["url"]}"

  client_cert = "${data.vault_generic_secret.matchbox.data["client_cert"]}"
  client_key = "${data.vault_generic_secret.matchbox.data["client_key"]}"
  ca_cert = "${data.vault_generic_secret.matchbox.data["ca_cert"]}"

  master_config = "${module.kubernetes.master-config}"
  worker_config = "${module.kubernetes.worker-config}"
}

data "vault_generic_secret" "digitalocean" {
  path = "secret/data/digitalocean"
}

data "vault_generic_secret" "packet" {
  path = "secret/data/packet"
}

data "vault_generic_secret" "matchbox" {
  path = "secret/data/matchbox"
}

data "vault_generic_secret" "cloudflare" {
  path = "secret/data/cloudflare"
}
