resource "tls_private_key" "cluster_admin" {
  algorithm   = "RSA"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "cluster_admin" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.cluster_admin.private_key_pem}"

  subject {
    organization = "system:masters"
    common_name  = "kubernetes-admin"
  }
}

resource "tls_locally_signed_cert" "cluster_admin" {
  cert_request_pem   = "${tls_cert_request.cluster_admin.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

locals {
  kubeconfig = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(tls_self_signed_cert.ca.cert_pem)}
    server: https://${var.api_server_hostname}:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: ${base64encode(tls_locally_signed_cert.cluster_admin.cert_pem)}
    client-key-data: ${base64encode(tls_private_key.cluster_admin.private_key_pem)}
EOF
}
