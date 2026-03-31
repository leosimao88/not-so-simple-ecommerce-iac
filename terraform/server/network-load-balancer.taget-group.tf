resource "aws_lb_target_group" "nlb_tcp" {
  name        = var.network_load_balancer.default_tg.target_group.name
  target_type = var.network_load_balancer.default_tg.target_group.target_type
  port        = var.network_load_balancer.default_tg.target_group.port
  protocol    = var.network_load_balancer.default_tg.target_group.protocol
  vpc_id      = data.aws_vpc.this.id
}