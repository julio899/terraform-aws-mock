# https://spacelift.io/blog/terraform-ecr
# How to import existing ECR repository into Terraform
# resource "aws_ecr_repository" "my_existing_repo" {
#   import {
#     to = "my_ecr_repo"
#     id = "existing-repo-name" # Replace with your existing repo name
#   }
# }

# Run the command replacing existing-repo-name with the actual name of your ECR repository:
# terraform import aws_ecr_repository.my_existing_repo existing-repo-name



# # Intentar obtener un repositorio existente con el nombre "neogaleno"
# data "aws_ecr_repository" "neogaleno" {
#   name = var.aws_ecr_repo_name  
# }

# # Crear el repositorio si no existe
# resource "aws_ecr_repository" "neogaleno_repo" {
#   count = length(data.aws_ecr_repository.neogaleno.id) == 0 ? 1 : 0  # Solo crear si no existe
#   name  =  var.aws_ecr_repo_name

#   tags = {
#     Name = var.aws_ecr_repo_name
#   }
# }


# Crear el repositorio (si no existe)
resource "aws_ecr_repository" "neogaleno_repo" {
  name = var.aws_ecr_repo_name
  tags = {
    Name = var.aws_ecr_repo_name
  }
  force_delete = false
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.stg_role.name}"
#   lifecycle {
#     prevent_destroy = true
#   }
}