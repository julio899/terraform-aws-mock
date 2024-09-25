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

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${aws_key_pair.deployer.key_name}-${lower("stg")}"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}