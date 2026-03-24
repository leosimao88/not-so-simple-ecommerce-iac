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
      vpc = "nsse-vpc"
    }
}

variable "control_plane_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    user_data                            = string
    ebs = object({
      size                  = number
      delete_on_termination = bool
    })
  })

  default = {
    name                                 = "nsse-production-debian-control-plane-lt"
    disable_api_stop                     = false
    disable_api_termination              = false
    instance_type                        = "t3.medium"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/control-plane-user-data.sh"
    ebs = {
      size                  = 20
      delete_on_termination = true
    }
  }
}