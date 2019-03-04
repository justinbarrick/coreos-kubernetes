variable "api_server_hostname" {}
variable "etcd_hostname" {}

variable "crictl_version" {
  default = "v1.11.1"
}

variable "kubernetes_version" {
  default = "v1.13.4"
}

variable "user_manifests" {
  default = ""
}

output "master-config" {
  value = "${data.ignition_config.master.rendered}"
}

output "worker-config" {
  value = "${data.ignition_config.worker.rendered}"
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
