resource "aws_iam_role" "stg_role" {
  name = "stg_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value-ec2"
  }
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.stg_role.name}"
}

# Crear la instancia EC2
resource "aws_instance" "stg" {
  ami                    = var.ami
  instance_type          = var.instance

  # importing EC2 Key Pair (ng-front-key): operation error EC2: ImportKeyPair, https response error StatusCode: 400
  key_name = aws_key_pair.deployer.key_name

  # Alternatively you could use the Terraform import command to import the pre-existing resource into your state file:
  # terraform import aws_key_pair.personal mschuchard-us-east

  tags = {
    Name = "docker-stg"
  }

  associate_public_ip_address = true

  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Provisión remota en la instancia EC2
 provisioner "remote-exec" {
  inline = [
      "uname -a",
      "docker -v",
      "docker-compose --version"
      // "$(aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin ${aws_ecr_repository.my_repo.repository_url})",
      // "git clone https://${var.github_user}:${var.github_token}@github.com/${var.GITHUB_WORKSPACE}/${var.GITHUB_REPOSITORY} && cd ${var.GITHUB_REPOSITORY}/",
      // "sudo docker build -t my-docker-repo .",
      // "sudo docker tag my-docker-repo:latest ${aws_ecr_repository.my_repo.repository_url}:latest",
      // "sudo docker push ${aws_ecr_repository.my_repo.repository_url}:latest"
    ]
    connection {
      type        = "ssh"
      user        = var.aws_ssh_user
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }
}