resource "aws_route_table" "private" {
  count = length(var.vpc_resources.private_subnets)
  
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = { Name = "${var.vpc_resources.name}-${var.vpc_resources.private_route_table_name}-${aws_subnet.private[count.index].availability_zone}" }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}