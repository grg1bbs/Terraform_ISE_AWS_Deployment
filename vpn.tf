/*
# Create Virtual Private Gateway
resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
  Name = "iselab-aws-vpngw"
  }
}

# Create Customer Gateway for On-Prem VPN headend; BGP ASN is default value due to static routing only
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = var.on_prem_gw_ip
  type       = "ipsec.1"
  device_name = "iselab-onprem-cgw"

  tags = {
    Name = "iselab-onprem-cgw"
  }
}

# Create the VPN connection using IKEv1
resource "aws_vpn_connection" "s2s_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  local_ipv4_network_cidr = var.on_prem_subnet
  remote_ipv4_network_cidr = var.vpc_cidr
  tunnel1_preshared_key = var.tunnel1_psk
  tunnel2_preshared_key = var.tunnel2_psk

  tags = {
    Name = "iselab-vpn"
  }
}

# VPN Static route for Local On-Prem Network
resource "aws_vpn_connection_route" "on_prem" {
  destination_cidr_block = var.on_prem_subnet
  vpn_connection_id      = aws_vpn_connection.s2s_vpn.id
}

# Subnet Static route for Local On-Prem Network
resource "aws_route" "r" {
  route_table_id            = aws_route_table.private_route.id
  destination_cidr_block    = var.on_prem_subnet
  gateway_id                = aws_vpn_gateway.vgw.id
  depends_on                = [aws_vpn_connection.s2s_vpn]
}

# VGW Attachment
resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = aws_vpc.vpc.id
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}
*/