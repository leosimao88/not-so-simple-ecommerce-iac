resource "aws_lb_listener" "nlb_control_plane" {
  load_balancer_arn = aws_lb.control_plane_nlb.arn
  port              = var.network_load_balancer.default_listener.port
  protocol          = var.network_load_balancer.default_listener.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tcp.arn
  }
}