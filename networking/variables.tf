variable "region" {
  default = "us-east-1"
}

variable "assume_role" {
  type = object({
    role_arn    = string,
    external_id = string
    profile     = string
  })

  default = {
    role_arn    = "arn:aws:iam::322095785990:role/terraform-role"
    external_id = "4440d132-b017-4f40-a6c6-0f69b7119c31"
    profile     = "Leonardo"
  }
}

variable "tags" {
  type = object({
    Project     = string
    Environment = string
  })

  default = {
    Project     = "nsse",
    Environment = "production"
  }
}
