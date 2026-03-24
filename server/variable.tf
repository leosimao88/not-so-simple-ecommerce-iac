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

variable "ec2_resources" {
  type = object({
    key_pair_name                = string,
    instance_profile             = string,
    instance_role                = string,
    ssh_security_group           = string,
    ssh_source_ip                = string

  })

  default = {
    key_pair_name                = "nsse-production-key-pair"
    instance_role                = "nsse-production-instance-role"
    instance_profile             = "nsse-production-instance-profile"
    ssh_security_group           = "allow-ssh"
    ssh_source_ip                = "0.0.0.0/0"
  }
}

variable "vpc_resources" {
    type = object({
      vpc = string
    })

    default = {
      vpc = "nsse-production-vpc"
    }
}