output "key_pair_private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "nlb_dns_name" {
  value = aws_lb.control_plane_nlb.dns_name
}


output "worker_launch_template_id" {
  value = module.ec2_workers_instances.launch_template_id
}

output "node_termination_queue_url" {
  value = aws_sqs_queue.node_termination.id
}