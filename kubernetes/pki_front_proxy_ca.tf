resource "tls_private_key" "front_proxy_ca" {
  algorithm   = "RSA"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "front_proxy_ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.front_proxy_ca.private_key_pem}"

  subject {
    common_name  = "front-proxy-ca"
  }

  is_ca_certificate = true

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing"
  ]
}

data "ignition_file" "front_proxy_ca_cert" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/front-proxy-ca.crt"
  mode = 493

  content {
    content = "${tls_self_signed_cert.front_proxy_ca.cert_pem}"
  }
}

data "ignition_file" "front_proxy_ca_key" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/front-proxy-ca.key"
  mode = 493

  content {
    content = "${tls_private_key.front_proxy_ca.private_key_pem}"
  }
}
