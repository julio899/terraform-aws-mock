# Output para imprimir la variable github_user
output "github_user_value" {
  description = "El nombre de usuario de GitHub"
  value       = var.github_user
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
  value       = var.aws_region
}
