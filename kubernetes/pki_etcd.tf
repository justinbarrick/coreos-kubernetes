data "ignition_file" "etcd_ca_cert" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/etcd/ca.crt"
  mode = 493

   content {
     content = "${tls_self_signed_cert.ca.cert_pem}"
   }
}

resource "tls_private_key" "etcd" {
  algorithm   = "RSA"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "etcd" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.etcd.private_key_pem}"

  subject {
    common_name  = "${var.etcd_hostname}"
  }
}

resource "tls_locally_signed_cert" "etcd" {
  cert_request_pem   = "${tls_cert_request.etcd.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

data "ignition_file" "etcd_cert" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/etcd/server.crt"
  mode = 493

   content {
     content = "${tls_locally_signed_cert.etcd.cert_pem}"
   }
}

data "ignition_file" "etcd_key" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/etcd/server.key"
  mode = 493

   content {
     content = "${tls_private_key.etcd.private_key_pem}"
   }
}

resource "tls_private_key" "etcd_client" {
  algorithm   = "RSA"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "etcd_client" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.etcd_client.private_key_pem}"

  subject {
    common_name  = "etcd-client"
  }
}

resource "tls_locally_signed_cert" "etcd_client" {
  cert_request_pem   = "${tls_cert_request.etcd_client.cert_request_pem}"
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

data "ignition_file" "etcd_client_cert" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/etcd/client.crt"
  mode = 493

   content {
     content = "${tls_locally_signed_cert.etcd_client.cert_pem}"
   }
}

data "ignition_file" "etcd_client_key" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/etcd/client.key"
  mode = 493

   content {
     content = "${tls_private_key.etcd_client.private_key_pem}"
   }
}
