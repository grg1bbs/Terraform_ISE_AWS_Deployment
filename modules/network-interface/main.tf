## Network Interface child module configuration

resource "aws_network_interface" "ise_gig0" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = var.security_groups
  tags = var.tags
}

output "private_ip" {
  value = aws_network_interface.ise_gig0
}