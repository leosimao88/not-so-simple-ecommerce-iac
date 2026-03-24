variable "region" {
  default = "us-east-1"
}

variable "vpc_resources" {
  type = object({
    vpc = string
  })

  default = {
    vpc = "nsse-vpc"

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

variable "assume_role" {
  type = object({
    profile     = string,
    role_arn    = string,
    external_id = string
  })

  default = {
    profile     = "Leonardo"
    role_arn    = "<YOUR_ROLE_ARN>"
    external_id = "<YOUR_EXTERNAL_ID>"
  }
}

variable "ec2_resources" {
  type = object({
    key_pair_name                = string,
    instance_profile             = string,
    instance_role                = string,
    control_plane_security_group = string,
    alb_security_group           = string,
    worker_security_group        = string,
  })

  default = {
    key_pair_name                = "nsse-production-key-pair"
    instance_role                = "nsse-production-instance-role"
    instance_profile             = "nsse-production-instance-profile"
    control_plane_security_group = "nsse-production-control-plane-security-group"
    alb_security_group           = "nsse-production-alb-security-group"
    worker_security_group        = "nsse-production-worker-security-group"
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
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.medium"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/control-plane-user-data.sh"
    ebs = {
      size                  = 20
      delete_on_termination = true
    }
  }
}

variable "worker_launch_template" {
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
    name                                 = "nsse-production-debian-worker-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/worker-user-data.sh"
    ebs = {
      size                  = 20
      delete_on_termination = true
    }
  }
}

variable "control_plane_auto_scaling_group" {
  type = object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })

  default = {
    name                      = "nsse-production-control-plane-asg"
    max_size                  = 2
    min_size                  = 2
    desired_capacity          = 2
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_tags = {
      Name = "nsse-production-control-plane"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}

variable "worker_auto_scaling_group" {
  type = object({
    name                            = string
    max_size                        = number
    min_size                        = number
    desired_capacity                = number
    health_check_grace_period       = number
    health_check_type               = string
    cluster_auto_scaler_policy_name = string
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })

  default = {
    name                            = "nsse-production-worker-asg"
    cluster_auto_scaler_policy_name = "nsse-production-cluster-autoscaler-policy"
    max_size                        = 5
    min_size                        = 4
    desired_capacity                = 4
    health_check_grace_period       = 180
    health_check_type               = "EC2"
    instance_tags = {
      Name = "nsse-production-worker"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}