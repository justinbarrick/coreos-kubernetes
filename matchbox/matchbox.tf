provider "matchbox" {
  endpoint    = "${var.matchbox_endpoint}"
  client_cert = "${var.client_cert}"
  client_key  = "${var.client_key}"
  ca          = "${var.ca_cert}"
}

resource "matchbox_profile" "master" {
  name = "master"

  kernel = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"

  initrd = [
    "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz",
    "https://github.com/cloudnativelabs/pxe/releases/download/v0.1.0-oem_packet.0/oem-packet.cpio.gz"
  ]

  args = [
    "coreos.config.url=${var.matchbox_url}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=ttyS1,115200n8",
    "coreos.autologin",
    "coreos.oem.id=packet"
  ]

  raw_ignition = "${var.master_config}"
}

resource "matchbox_profile" "worker" {
  name = "worker"

  kernel = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"

  initrd = [
    "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz",
    "https://github.com/cloudnativelabs/pxe/releases/download/v0.1.0-oem_packet.0/oem-packet.cpio.gz"
  ]

  args = [
    "coreos.config.url=${var.matchbox_url}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=ttyS1,115200n8",
    "coreos.autologin",
    "coreos.oem.id=packet"
  ]

  raw_ignition = "${var.worker_config}"
}

resource "matchbox_group" "default" {
  name = "default"
  profile = "${matchbox_profile.worker.name}"
}

resource "matchbox_group" "master" {
  name = "master"
  profile = "${matchbox_profile.master.name}"

  selector {
    mac = "52:54:00:a1:9c:ae"
  }
}

output "ipxe-url" {
  value = "${var.matchbox_url}/boot.ipxe"
}
