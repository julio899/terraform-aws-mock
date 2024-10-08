# Output para imprimir la variable github_user
output "github_user_value" {
  description = "El nombre de usuario de GitHub"
  value       = var.GITHUB_USER
}
/*
output "github_token" {
  description = "github_token"
  value       = var.github_token
}

output "AWS_ACCESS_KEY_ID" {
  description = "AWS_ACCESS_KEY_ID"
  value       = var.AWS_ACCESS_KEY_ID
}

output "AWS_SECRET_ACCESS_KEY" {
  description = "AWS_SECRET_ACCESS_KEY"
  value       = var.AWS_SECRET_ACCESS_KEY
}
*/
output "aws_region" {
  description = "aws_region"
  value       = var.AWS_REGION
}


# output "aws_key_pair" {
#   description = "aws_key_pair key_name"
#   value       = aws_key_pair.deployer.key_name
# }


output "allocation_id" {
  description = "la Elastic IP a la instancia EC2 allocation_id"
  value       = aws_eip_association.eip_assoc.allocation_id
}

output "instance_id" {
  description = "la Elastic IP a la instancia EC2 instance_id"
  value       = aws_eip_association.eip_assoc.instance_id
}


output "repository_url" {
  description = "ecr repository url"
  value       = "${var.AWS_ECR_REPO_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com"
  # aws_ecr_repository.neogaleno_repo.repository_url
}


output "ip_stg" {
  description = "stg ip aws_eip_association"
  value       = aws_eip_association.eip_assoc.public_ip
  # aws_ecr_repository.neogaleno_repo.repository_url
}




output "aws_ecr_repo_name" {
  description = "ecr name"
  value       = var.AWS_ECR_REPO_NAME
  # aws_ecr_repository.neogaleno_repo.id
}


output "aws_ecr_repo_id" {
  description = "ecr registry id"
  value       = var.AWS_ECR_REPO_ID
  # aws_ecr_repository.neogaleno_repo.registry_id
}


output "ssh_conexion" {
  description = "ssh"
  # value       = "ssh -i keypairs/${aws_key_pair.deployer.key_name}.pem ubuntu@${var.AWS_IP_STG}"
  value = "ssh -o StrictHostKeyChecking=no -i ~/.ssh/terraform ubuntu@${var.AWS_IP_STG}"
}

# # Output para verificar el repositorio usado
# output "repository_url" {
#   description = "repositorio ecr usado"
#   value = coalesce( data.aws_ecr_repository.neogaleno.repository_url, aws_ecr_repository.neogaleno_repo.repository_url)
# }

# # Output para generar dinámicamente el comando de Docker login
# output "docker_login_command" {
#   value = "aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin ${coalesce(data.aws_ecr_repository.neogaleno.repository_url, aws_ecr_repository.neogaleno_repo[0].repository_url)}:latest"
#   // "aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin ${coalesce(data.aws_ecr_repository.neogaleno.repository_url, aws_ecr_repository.neogaleno_repo.repository_url)}"
# }