# Terraform_ISE_AWS_Deployment
Terraform code for creating a lab environment in AWS using Cisco ISE 3.1 and the necessary AWS environment constructs (VPC, Subnets, Security Group, NAT and Interet Gateways, Route Tables, etc)

This code was validated using:
 - ISE 3.1 AMI (ap-southeast-2 region) from the AWS Marketplace
 - Terraform version 1.3.5
 - Terraform AWS provider version 4.43.0
 
 The following 21 resources are created by this Terraform code:
  - VPC (In the ap-southeast-2 region; Availibility zones 2a & 2b)
  - 2x Public Subnets & 2x Private Subnets; one in each AZ
  - A public Internet Gateway
  - A NAT Gateway for the Private Subnets (including an Elastic IP)
  - Route Tables and the necessary associations for the Public and Private Subnets
  - Basic Security Group for the ISE nodes
  - 2x ISE EC2 instances in the Private Subnets; one in each AZ
  
  # Pre-requisites
   - Terraform application installed
   - Necessary AWS IAM credentials and roles
   - AWS key pair for SSH
   
   See the following guide for how to get started using Terraform and AWS:
   
   https://registry.terraform.io/providers/hashicorp/aws/latest/docs
   
   See the following guide for how to create an EC2 key pair for a Linux instance:
   
   https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
   
   
