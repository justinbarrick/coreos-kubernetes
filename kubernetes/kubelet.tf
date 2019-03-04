data "ignition_systemd_unit" "docker" {
  name = "docker.service"
  enabled = true
}

data "ignition_systemd_unit" "kubelet" {
  name = "kubelet.service"
  enabled = true

  content = <<EOF
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=http://kubernetes.io/docs/

[Service]
ExecStartPre=/opt/bin/install-kubeadm.sh
ExecStart=/opt/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

  dropin = [
    {
      name = "10-kubeadm.conf"
      content = "${file("${path.module}/units/kubelet.service")}"
    }
  ]
}
