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

variable "AWS_ACCESS_KEY_ID" {
  description = "aws_access_key_id"
  type        = string
  default     = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "aws_secret_access_key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "aws_region"
  type        = string
  default     = "us-east-1"
}

variable "instance" {
  description = "instance"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-0e86e20dae9224db8"
}

variable "aws_ssh_user" {
  description = "aws_ssh_user"
  type        = string
  default     = "ubuntu"
}

variable "TF_VAR_GITHUB_REPOSITORY" {
  description = "TF_VAR_GITHUB_REPOSITORY"
  type        = string
  default     = ""
}

variable "TF_VAR_GITHUB_TOKEN" {
  description = "TF_VAR_GITHUB_TOKEN"
  type        = string
  default     = ""
}

variable "TF_VAR_GITHUB_USER" {
  description = "TF_VAR_GITHUB_USER"
  type        = string
  default     = ""
}


variable "TF_VAR_GITHUB_WORKSPACE" {
  description = "TF_VAR_GITHUB_WORKSPACE"
  type        = string
  default     = ""
}
