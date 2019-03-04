data "template_file" "cilium" {
  template = "${file("${path.module}/manifests/cilium.yaml")}"

  vars = {
    etcd_hostname = "${var.etcd_hostname}"
  }
}

data "ignition_file" "cilium" {
  filesystem = "root"
  path = "/etc/kubernetes/bootstrap-manifests/cilium.yaml"
  mode = 420
  content {
    content = "${data.template_file.cilium.rendered}"
  }
}

data "ignition_file" "user_manifests" {
  filesystem = "root"
  path = "/etc/kubernetes/bootstrap-manifests/user.yaml"
  mode = 420
  content {
    content = "${var.user_manifests}"
  }
}

data "ignition_file" "bootstrap_job" {
  filesystem = "root"
  path = "/etc/kubernetes/manifests/bootstrap.yaml"
  mode = 420
  content {
    content = "${file("${path.module}/manifests/bootstrap.yaml")}"
  }
}
