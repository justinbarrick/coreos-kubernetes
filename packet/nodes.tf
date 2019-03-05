provider "packet" {
  auth_token = "${var.auth_token}"
}

locals {
  project_id = "ba42c0a6-29d0-4bb3-8c03-0c6e923dc75e"
}

resource "packet_project_ssh_key" "access" {
  name = "access"
  public_key = "${var.ssh_public_key}"
  project_id = "${local.project_id}"
}

resource "packet_device" "master" {
  count            = "${var.num_master_nodes}"

  hostname         = "master-${count.index}"
  plan             = "c2.medium.x86"
  facilities         = ["sjc1"]
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"

  project_ssh_key_ids = ["${packet_project_ssh_key.access.id}"]

  ipxe_script_url  = "${var.ipxe_url}"
  always_pxe       = "${var.ipxe_url != "" ? "true" : "false"}"
  operating_system = "${var.ipxe_url != "" ? "custom_ipxe" : "coreos_stable"}"

  user_data = "${var.master_config}"
}

resource "packet_device" "worker" {
  count            = "${var.num_worker_nodes}"

  hostname         = "worker-packet-${count.index}"
  plan             = "c2.medium.x86"
  facilities         = ["sjc1"]
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"

  project_ssh_key_ids = ["${packet_project_ssh_key.access.id}"]

  ipxe_script_url  = "${var.ipxe_url}"
  always_pxe       = "${var.ipxe_url != "" ? "true" : "false"}"
  operating_system = "${var.ipxe_url != "" ? "custom_ipxe" : "coreos_stable"}"

  user_data = "${var.worker_config}"
}

output "master-ips" {
  value = ["${packet_device.master.*.access_public_ipv4}"]
}

output "master-ips-private" {
  value = ["${packet_device.master.*.access_private_ipv4}"]
}

output "worker_ips" {
  value = ["${packet_device.worker.*.access_public_ipv4}"]
}
