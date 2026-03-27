terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nsse-terraform-state-files-lsa"
    key            = "networking/terraform.tfstate"
    region         = "us-east-1"
    profile        = "Leonardo"
    dynamodb_table = "nsse-terraform-state-locking-lsa"
  }
}

provider "aws" {
  region  = var.region
  profile = var.assume_role.profile

  default_tags {
    tags = var.tags
  }

  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}
