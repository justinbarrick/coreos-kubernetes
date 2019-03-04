provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_droplet" "master" {
  count = "${var.num_master_nodes}"

  image  = "coreos-stable"
  name   = "master-${count.index}"
  region = "tor1"
  size   = "s-2vcpu-2gb"

  ssh_keys = "${var.ssh_fingerprints}"

  private_networking = true

  user_data = "${var.master_config}"
}

resource "digitalocean_droplet" "worker" {
  count = "${var.num_worker_nodes}"

  image  = "coreos-stable"
  name   = "worker-${count.index}"
  region = "tor1"
  size   = "s-2vcpu-2gb"

  ssh_keys = "${var.ssh_fingerprints}"

  private_networking = true

  user_data = "${var.worker_config}"
}

output "master-ips" {
  value = "${digitalocean_droplet.master.*.ipv4_address}"
}

output "master-ips-private" {
  value = "${digitalocean_droplet.master.*.ipv4_address_private}"
}

output "worker_ips" {
  value = "${digitalocean_droplet.worker.*.ipv4_address}"
}
