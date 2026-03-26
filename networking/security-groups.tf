resource "aws_security_group" "control_plane" {
  name   = "nsse-production-control-plane-security-group"
  vpc_id = aws_vpc.this.id

  tags = { Name = "nsse-production-control-plane-security-group" }
}

resource "aws_security_group" "worker" {
  name   = "nsse-production-worker-security-group"
  vpc_id = aws_vpc.this.id

  tags = { Name = "nsse-production-worker-security-group" }
}
