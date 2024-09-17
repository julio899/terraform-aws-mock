# Definición de la variable (puede estar en variables.tf)
variable "github_user" {
  description = "usuario de GitHub"
  type        = string
  default     = "default_user"
}
variable "github_workspace" {
  description = "workspace de GitHub"
  type        = string
  default     = ""
}
variable "github_repository" {
  description = "repository de GitHub"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "token de GitHub"
  type        = string
  default     = "default_user"
}

variable "aws_access_key_id" {
  description = "aws_access_key_id"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "aws_secret_access_key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "aws_region"
  type        = string
  default     = "us-east-1"
}