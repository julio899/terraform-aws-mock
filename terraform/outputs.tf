# Output para imprimir la variable github_user
output "github_user_value" {
  description = "El nombre de usuario de GitHub"
  value       = var.github_user
}

output "github_token" {
  description = "github_token"
  value       = var.github_token
}

output "aws_access_key_id" {
  description = "aws_access_key_id"
  value       = var.aws_access_key_id
}

output "aws_secret_access_key" {
  description = "aws_secret_access_key"
  value       = var.aws_secret_access_key
}

output "aws_region" {
  description = "aws_region"
  value       = var.aws_region
}
