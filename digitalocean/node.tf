provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "ansible" {
  count = 1
  name       = "ansible-${count.index}"
  public_key = "${element(var.ssh_public_keys, count.index)}"
}

resource "digitalocean_droplet" "master" {
  count = "${var.num_master_nodes}"

  image  = "coreos-stable"
  name   = "master-${count.index}"
  region = "sfo2"
  size   = "s-2vcpu-2gb"

  ssh_keys = [
    "${var.ssh_fingerprints}",
    "${digitalocean_ssh_key.ansible.*.id}"
  ]

  private_networking = true

  user_data = "${var.master_config}"

  lifecycle {
    ignore_changes = ["volume_ids"]
  }
}

resource "digitalocean_droplet" "worker" {
  count = "${var.num_worker_nodes}"

  image  = "coreos-stable"
  name   = "worker-${count.index}"
  region = "sfo2"
  size   = "s-2vcpu-2gb"

  ssh_keys = [
    "${var.ssh_fingerprints}",
    "${digitalocean_ssh_key.ansible.*.id}"
  ]

  private_networking = true

  user_data = "${var.worker_config}"

  lifecycle {
    ignore_changes = ["volume_ids"]
  }
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
