
# Create Security Group for ISE
resource "aws_security_group" "ise_network_access" {
    name = "ise-network-access"
    vpc_id      = aws_vpc.vpc.id
    description = "Allow traffic for ISE"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Allow all outbound"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    ingress     = [
        {
            cidr_blocks      = [
                var.vpc_cidr,
                var.on_prem_subnet,
            ]
            description      = "Allow all from On-Prem network and VPC subnets"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
}