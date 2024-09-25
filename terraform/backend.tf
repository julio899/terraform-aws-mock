terraform {
  backend "s3" {
    bucket  = "ng-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
