data "ignition_file" "resolv_conf" {
  filesystem = "root"
  path = "/etc/resolv.conf"
  mode = 420
  content {
    content = "nameserver 1.1.1.1"
  }
}

locals {
  systemd = [
    "${data.ignition_systemd_unit.docker.id}",
    "${data.ignition_systemd_unit.kubelet.id}",
    "${data.ignition_systemd_unit.setup_kubeadm.id}"
  ]

  files = [
    "${data.ignition_file.install_kubeadm_sh.id}",
    "${data.ignition_file.setup_kubeadm_sh.id}",
    "${data.ignition_file.resolv_conf.id}",
    "${data.ignition_file.bootstrap_job.id}",
    "${data.ignition_file.cilium.id}",
    "${data.ignition_file.user_manifests.id}",
  ]
}

data "ignition_config" "master" {
  systemd = [
    "${local.systemd}",
    "${data.ignition_systemd_unit.etcd.id}"
  ]

  files = [
    "${data.ignition_file.kubeadm_conf_master.id}",
    "${data.ignition_file.ca_cert.id}",
    "${data.ignition_file.ca_key.id}",
    "${data.ignition_file.front_proxy_ca_cert.id}",
    "${data.ignition_file.front_proxy_ca_key.id}",
    "${data.ignition_file.sa_key.id}",
    "${data.ignition_file.sa_pub.id}",
    "${local.files}"
  ]
}

data "ignition_config" "worker" {
  systemd = [
    "${local.systemd}"
  ]

  files = [
    "${local.files}",
    "${data.ignition_file.kubeadm_conf_worker.id}",
  ]
}
