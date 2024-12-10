resource "tls_private_key" "rsa" {
  algorithm = "RSA"

  rsa_bits = 4096
}

resource "aws_key_pair" "rsa_key" {
  key_name = var.keyname

  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "instance_key" {
  content         = tls_private_key.rsa.private_key_pem
  file_permission = "776"
  filename        = "${var.keyname}.pem"
} 