terraform {
  backend "s3" {
    bucket  = "ng-terraform-state"
    key     = "terraform.tfstate"
    region  = "${var.AWS_REGION}"
    encrypt = true
    access_key = "${var.AWS_ACCESS_KEY_ID}"
    secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
  }
}
