# Definir el repositorio de ECR
resource "aws_ecr_repository" "neogaleno" {
  name = "neogaleno"

  # Evitar la destrucción del repositorio ECR
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "neogaleno-repo"
  }
}

# Output de la URL del repositorio ECR
output "repository_url" {
  value = aws_ecr_repository.neogaleno.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.neogaleno.name
}
