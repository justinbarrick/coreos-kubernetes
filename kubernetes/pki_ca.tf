resource "tls_private_key" "ca" {
  algorithm   = "RSA"
  rsa_bits    = "4096"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "${var.api_server_hostname}"
  }

  is_ca_certificate = true

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing"
  ]
}

data "ignition_file" "ca_cert" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/ca.crt"
  mode = 493

  content {
    content = "${tls_self_signed_cert.ca.cert_pem}"
  }
}

data "ignition_file" "ca_key" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/ca.key"
  mode = 493

  content {
    content = "${tls_private_key.ca.private_key_pem}"
  }
}

data "tls_public_key" "ca" {
  private_key_pem = "${tls_private_key.ca.private_key_pem}"
}

data "external" "ca_key_hash" {
  program = [
    "bash", "-c",
    "jq -r .key |openssl rsa -pubin -outform der |sha256sum |awk '{print $$1}' |jq -sR '{hash:.}'"
  ]

  query {
    key = "${data.tls_public_key.ca.public_key_pem}"
  }
}

locals {
  ca_key_hash = "${data.external.ca_key_hash.result["hash"]}"
}
