generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
 terraform {
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "5.76.0"
     }
   }
 }
provider "aws" {
  region = "us-east-1"
 }
 EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "ENTER_BUCKET_NAME"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
}
 EOF
} 