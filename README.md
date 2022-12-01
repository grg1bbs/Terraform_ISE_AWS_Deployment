# Terraform_ISE_AWS_Deployment
Terraform code for creating a lab environment in AWS using Cisco ISE 3.1 and the necessary AWS environment constructs (VPC, Subnets, Security Group, NAT and Interet Gateways, Route Tables, etc).

I built this code so that I could quickly spin up ISE nodes in AWS (they still take ~30min to complete building), test what I need, and tear the lab environment down when I am finished.
The code for the ISE resources can be scaled up/down as needed and used for either non-production or production environments.

This code was validated using:
 - ISE 3.1 AMI (ap-southeast-2 region) from the AWS Marketplace
 - Terraform version 1.3.5
 - Terraform AWS provider version 4.43.0
 - (Site-to-Site VPN) Cisco ASA 5506-X (Security Plus license) running software version 9.16(3)23
 
 The following resources are created by this Terraform code:
  - VPC (In the ap-southeast-2 region; Availibility zones 2a & 2b)
  - 2x Public Subnets & 2x Private Subnets; one in each AZ
  - A public Internet Gateway
  - A NAT Gateway for the Private Subnets (including an Elastic IP)
  - Route Tables and the necessary associations for the Public and Private Subnets
  - Basic Security Group for the ISE nodes
  - 2x ISE EC2 instances in the Private Subnets; one in each AZ
  - (Optional) Site-to-Site VPN gateway, customer gateway, and related static routes and attachments
  
## Pre-requisites
   - Terraform application installed
   - Necessary AWS IAM credentials and roles
   - AWS key pair for SSH
   
   See the following guide for how to get started using Terraform and AWS:
   
   https://registry.terraform.io/providers/hashicorp/aws/latest/docs
   
   See the following guide for how to create an EC2 key pair for a Linux instance:
   
   https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
   
## Topology Diagram
The following diagram represents the basic topology built by this code. The on-prem 'Home Lab Network' is shown for reference only. No on-prem resources are created by this code.

<img width="888" alt="aws iselab diagram" src="https://user-images.githubusercontent.com/103554967/204721904-557443dc-79df-4290-922f-5338cadfe6bd.png">

## Quick Start
1. Clone this repository:  

    ```bash
    git clone https://github.com/grg1bbs/Terraform_ISE_AWS_Deployment
    ```
 
2. Edit the 'variables.tf' file to suit your environment (Subnets, Availability Zones, ISE AMI for your region, ISE EC2 instance size, ISE node IP addresses, etc.)

3. Update the user data text files (ise31aws1.txt, ise31aws2.txt) to replace the <variables> to suit your environment. If preferred, change the hostname to suit your naming convention.

    See [Deploy Cisco Identity Services Engine Natively on Cloud Platforms](https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEaaS.html) for guidance.

4. If needed, update the 'sg.tf' file to provide greater restrictions for the Security Group

5. *Optional* - The code includes optional files and variables for building a site-to-site VPN tunnel with an on-prem VPN headend. This was validated using an on-prem Cisco ASA.

    If you want to create these site-to-site VPN resources, perform the following:
     - Un-comment the code in the 'vpn.tf' file (by removing the '/*' and '*/' characters)
     - Un-comment the code in the 'variables.tf' and update the variables with your tunnel pre-shared keys and vpn headend IP
     - Un-comment the code in the 'outputs.tf' file; this will inform terraform to print out the VPN tunnel IP addresses generated by AWS after they are created
    
    Example ASA configuration can be found in the 'asa_vpn.txt' file in this repository

6. Initialise, Plan, and Apply the terraform run

    ```bash
    terraform init
    
    terraform plan
    
    terraform apply
    ```
    
### Results *without* the optional site-to-site VPN resources
Unless any errors are found, after the resource build is complete, the resulting status should be:

```diff
+ Apply complete! Resources: 21 added, 0 changed, 0 destroyed.
```

If you check the terraform state, you should see the following resources:
 
```bash
> terraform state list
aws_eip.nat_eip
aws_instance.ise31aws1
aws_instance.ise31aws2
aws_internet_gateway.igw
aws_nat_gateway.natgw
aws_network_interface.ise31aws1_gig0
aws_network_interface.ise31aws2_gig0
aws_route.private_nat_gateway
aws_route.public_internet_gateway
aws_route_table.private_route
aws_route_table.public_route
aws_route_table_association.private[0]
aws_route_table_association.private[1]
aws_route_table_association.public[0]
aws_route_table_association.public[1]
aws_security_group.ise_network_access
aws_subnet.private_subnet[0]
aws_subnet.private_subnet[1]
aws_subnet.public_subnet[0]
aws_subnet.public_subnet[1]
aws_vpc.vpc
```

### Results *with* the optional site-to-site VPN resources

```diff
+ Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

+ Outputs:

tunnel1_gw_ip = "<gw_ip1>"
tunnel2_gw_ip = "<gw_ip2>"
```

If you check the terraform state, you should see the following resources:
 
```bash
> terraform state list
aws_customer_gateway.cgw
aws_eip.nat_eip
aws_instance.ise31aws1
aws_instance.ise31aws2
aws_internet_gateway.igw
aws_nat_gateway.natgw
aws_network_interface.ise31aws1_gig0
aws_network_interface.ise31aws2_gig0
aws_route.private_nat_gateway
aws_route.public_internet_gateway
aws_route.r
aws_route_table.private_route
aws_route_table.public_route
aws_route_table_association.private[0]
aws_route_table_association.private[1]
aws_route_table_association.public[0]
aws_route_table_association.public[1]
aws_security_group.ise_network_access
aws_subnet.private_subnet[0]
aws_subnet.private_subnet[1]
aws_subnet.public_subnet[0]
aws_subnet.public_subnet[1]
aws_vpc.vpc
aws_vpn_connection.s2s_vpn
aws_vpn_connection_route.on_prem
aws_vpn_gateway.vgw
aws_vpn_gateway_attachment.vpn_attachment
```

### Teardown
To tear down the entire environment, use 'terraform destroy' and the dependency mappings will ensure everything is destroyed in the correct order.

```bash
> terraform destroy
```

Unless any errors are found, after the resource destroy process is complete, the resulting status (with the optional VPN resources) should be:

```diff
+ Destroy complete! Resources: 27 destroyed.
```

#### Additional Note
The aws_instance resources in the 'ise.tf' file that are used to create the ISE EC2 instances include an optional block for:
```bash
  lifecycle {
    ignore_changes = [user_data]
  }
```

This was included due to a customer concern of having the cleartext password stored in the 'ise31aws1.txt' and 'ise31aws2.txt' files used for the user_data. This allows the passwords to be changed in these files after the initial deployment without causing a change/rebuild of those resources by terraform.

This block can be removed from those resource blocks if preferred.
