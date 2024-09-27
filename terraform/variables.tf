# Definición de la variable (puede estar en variables.tf)
variable "GITHUB_USER" {
  description = "usuario de GitHub"
  type        = string
  default     = "default_user"
}
variable "GITHUB_WORKSPACE" {
  description = "workspace de GitHub"
  type        = string
  default     = ""
}
variable "GITHUB_REPOSITORY" {
  description = "repository de GitHub"
  type        = string
  default     = ""
}

variable "GITHUB_TOKEN" {
  description = "access token de GitHub"
  type        = string
  default     = ""
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

variable "AWS_REGION" {
  description = "aws_region"
  type        = string
  default     = "us-east-1"
}

variable "INSTANCE" {
  description = "instance"
  type        = string
  default     = "t2.micro"
}

variable "AMI" {
  description = "ami"
  type        = string
  default     = "ami-0e86e20dae9224db8"
}

variable "AWS_SSH_USER" {
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

variable "AWS_ECR_REPO_NAME" {
  description = "aws_ecr_repo_name"
  type        = string
  default     = "neogaleno"
}


variable "AWS_ECR_REPO_ID" {
  description = "aws_ecr_repo_id creado previamiente en ecr id del repo"
  type        = string
  default     = ""
}

variable "SSH_TERRAFORM_PUBLIC_KEY" {
  description = "SSH_TERRAFORM_PUBLIC_KEY ssh .pub"
  type        = string
  default     = ""
}

variable "SSH_TERRAFORM_PRIV_KEY" {
  description = "SSH_TERRAFORM_PRIV_KEY ssh"
  type        = string
  default     = ""
}


# # # # # # # # 
# FRONT - ENV #
# # # # # # # # 
variable "FRONT_ENVIROMENT" {
  type    = string
  default = ""
}
variable "FRONT_NODE_ENV" {
  type    = string
  default = ""
}
variable "FRONT_MIXPANEL_KEY" {
  type    = string
  default = ""
}
variable "FRONT_NG_AWS_ACCESS_KEY" {
  type    = string
  default = ""
}
variable "FRONT_NG_AWS_SECRET_KEY" {
  type    = string
  default = ""
}
variable "FRONT_NG_AWS_BUCKET" {
  type    = string
  default = ""
}
variable "FRONT_NG_AWS_REGION" {
  type    = string
  default = ""
}

variable "FRONT_NG_AWS_S3_URL" {
  type    = string
  default = ""
}

variable "FRONT_SENTRY_DNS" {
  type    = string
  default = ""
}

variable "FRONT_STRIPE_BILLING_URL" {
  type    = string
  default = ""
}

variable "FRONT_VUE_APP_BACKEND_DOMAIN" {
  type    = string
  default = ""
}

variable "FRONT_VUE_APP_LANDING_DOMAIN" {
  type    = string
  default = ""
}

variable "FRONT_CORS" {
  type    = string
  default = ""
}
variable "FRONT_PORT" {
  type    = string
  default = ""
}
variable "FRONT_API_VERSION" {
  type    = string
  default = ""
}
variable "FRONT_DEMO_USER" {
  type    = string
  default = ""
}
variable "FRONT_DEMO_USER_PASS" {
  type    = string
  default = ""
}
variable "FRONT_SERVER_IP" {
  type    = string
  default = ""
}
variable "FRONT_SERVER_USER" {
  type    = string
  default = ""
}
variable "FRONT_SERVER_CERT_SSH" {
  type    = string
  default = ""
}

variable "AWS_IP_STG" {
  type    = string
  default = ""
}

variable "AWS_VOLUME" {
  type    = string
  default = "" // vol-0exxxx78  
}

# Asume que ya tienes una Elastic IP existente con ID "eipalloc-xxxxxxxx"
variable "AWS_IP_STG_EIPALLOC" {
  type    = string
  default = "eipalloc-xxxxxxxx" # Coloca aquí tu EIP ID
}