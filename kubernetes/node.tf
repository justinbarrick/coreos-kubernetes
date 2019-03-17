resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
  rsa_bits = "2048"
}

data "ignition_file" "ssh_key" {
  filesystem = "root"
  path = "/etc/ansible/ssh_key"
  mode = 384
  content {
    content = "${tls_private_key.ssh_key.private_key_pem}"
  }
}

data "ignition_systemd_unit" "ansible-bootstrap" {
    name = "ansible-bootstrap.service"

    content = <<EOF
[Unit]
Requires=docker.service
After=docker.service
ConditionPathExists=!/etc/kubernetes/kubelet.conf

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run --restart=on-failure --net=host -v /etc/ansible/ssh_key:/etc/ansible/ssh_key:ro --entrypoint ansible-runner justinbarrick/ansible-test -p /opt/ansible/playbook.yaml --inventory /etc/ansible/hosts run /tmp/private

[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_config" "node" {
  systemd = [
    "${data.ignition_systemd_unit.ansible-bootstrap.id}"
  ]

  files = [
    "${data.ignition_file.metadata.id}",
    "${data.ignition_file.etcd_ca_cert.id}",
    "${data.ignition_file.etcd_client_cert.id}",
    "${data.ignition_file.etcd_client_key.id}",
    "${data.ignition_file.ssh_key.id}",
    "${data.ignition_file.etcd_cert.id}",
    "${data.ignition_file.etcd_key.id}"
  ]
}
