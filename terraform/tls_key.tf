resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  # key_name   = "${var.github_repository}-key"
  # uuid() "stg-key"
  key_name   = uuid()
  public_key = tls_private_key.key.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.deployer.key_name}-STG.pem"
  content  = tls_private_key.key.private_key_pem
  // .private_key_pem
}