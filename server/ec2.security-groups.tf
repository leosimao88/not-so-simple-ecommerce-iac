resource "aws_security_group" "control_plane" {
  name        = var.ec2_resources.control_plane_security_group
  description = "Control plane security group"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.ec2_resources.control_plane_security_group })
}

resource "aws_security_group" "worker" {
  name        = var.ec2_resources.worker_security_group
  description = "Worker nodes security group"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description     = "Allow all traffic from control plane"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.control_plane.id]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.ec2_resources.worker_security_group })
}