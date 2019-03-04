resource "random_string" "kubeadm_token" {
  count = 2

  length = "${count.index == 0 ? 6 : 16}"

  special = false
  upper   = false
  lower   = true
}

locals {
  kubeadm_token = "${random_string.kubeadm_token.0.result}.${random_string.kubeadm_token.1.result}"
}

data "template_file" "install_kubeadm_sh" {
  template = "${file("${path.module}/scripts/install-kubeadm.sh")}"

  vars = {
    kubernetes_version = "${var.kubernetes_version}"
    crictl_version = "${var.crictl_version}"
  }
}

data "ignition_file" "install_kubeadm_sh" {
  filesystem = "root"
  path = "/opt/bin/install-kubeadm.sh"
  mode = 493

  content {
    content = "${data.template_file.install_kubeadm_sh.rendered}"
  }
}

data "ignition_file" "setup_kubeadm_sh" {
  filesystem = "root"
  path = "/opt/bin/setup-kubeadm.sh"
  mode = 493

  content {
    content = "${file("${path.module}/scripts/setup-kubeadm.sh")}"
  }
}

data "ignition_systemd_unit" "setup_kubeadm" {
  name = "setup-kubeadm.service"
  enabled = true
  content = "${file("${path.module}/units/setup-kubeadm.service")}"
}

data "template_file" "kubeadm_conf" {
  template = "${file("${path.module}/kubeadm.conf")}"

  vars = {
    kubernetes_version = "${var.kubernetes_version}"
    etcd_hostname = "${var.etcd_hostname}"
    api_server_hostname = "${var.api_server_hostname}"
    kubeadm_token = "${local.kubeadm_token}"
    ca_key_hash = "${local.ca_key_hash}"
  }
}

data "ignition_file" "kubeadm_conf_master" {
  filesystem = "root"
  path = "/etc/kubeadm.conf"
  mode = 493

  content {
    content = <<EOF
${data.template_file.kubeadm_conf.rendered}
controlPlane:
  localAPIEndpoint:
    bindPort: 6443
EOF
  }
}

data "ignition_file" "kubeadm_conf_worker" {
  filesystem = "root"
  path = "/etc/kubeadm.conf"
  mode = 493

  content {
    content = "${data.template_file.kubeadm_conf.rendered}"
  }
}
