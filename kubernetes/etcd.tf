resource "etcdiscovery_token" "token" {}

data "template_file" "etcd_service" {
  template = "${file("${path.module}/units/etcd.service")}"
  vars = {
    etcd_discovery_token = "${etcdiscovery_token.token.id}"
  }
}

data "ignition_systemd_unit" "etcd" {
  name = "etcd-member.service"
  enabled = true

  dropin {
    name = "20-etcd-member.conf"
    content = "${data.template_file.etcd_service.rendered}"
  }
}
