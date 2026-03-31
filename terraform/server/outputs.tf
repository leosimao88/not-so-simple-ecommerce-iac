output "key_pair_private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "nlb_dns_name" {
  value = aws_lb.control_plane_nlb.dns_name
}

