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