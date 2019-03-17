variable "api_server_hostname" {}
variable "etcd_hostname" {}

variable "crictl_version" {
  default = "v1.11.1"
}

variable "kubernetes_version" {
  default = "v1.13.4"
}

output "ca" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "ca_key_hash" {
  value = "${local.ca_key_hash}"
}

output "master-config" {
  value = "${data.ignition_config.master.rendered}"
}

output "worker-config" {
  value = "${data.ignition_config.worker.rendered}"
}

output "ssh-public-key" {
  value = "${tls_private_key.ssh_key.public_key_openssh}"
}
