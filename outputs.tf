/*
# Outputs showing Tunnel1 and Tunnel2 IP addresses
output "tunnel1_gw_ip" {
  value = aws_vpn_connection.s2s_vpn.tunnel1_address
}
output "tunnel2_gw_ip" {
  value = aws_vpn_connection.s2s_vpn.tunnel2_address
}
*/