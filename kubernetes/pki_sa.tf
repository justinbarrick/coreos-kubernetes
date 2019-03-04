resource "tls_private_key" "sa" {
  algorithm   = "RSA"
  rsa_bits    = "4096"
}

data "tls_public_key" "sa" {
  private_key_pem = "${tls_private_key.sa.private_key_pem}"
}


data "ignition_file" "sa_pub" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/sa.pub"
  mode = 493

  content {
    content = "${data.tls_public_key.sa.public_key_pem}"
  }
}


data "ignition_file" "sa_key" {
  filesystem = "root"
  path = "/etc/kubernetes/pki/sa.key"
  mode = 493

  content {
    content = "${tls_private_key.sa.private_key_pem}"
  }
}
