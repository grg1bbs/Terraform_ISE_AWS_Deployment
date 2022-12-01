variable "vpc_cidr" {
  default = "172.32.32.0/24"
  description = "CIDR block used for the VPC"
}
variable "on_prem_subnet" {
  default = "192.168.0.0/16"
  description = "CIDR block for on-prem network; used for VPN routing and Security Group"
}
variable "iselab_az" {
  type = list(string)
  default = ["ap-southeast-2a","ap-southeast-2b"]
  description = "Availability Zones referenced in 'vpc.tf' when creating the subnets"
}
variable "iselab_az1" {
  default = "ap-southeast-2a"
}
variable "iselab_az2" {
  default = "ap-southeast-2b"
}
variable "public_subnets_cidr" {
  type = list(string)
  default = ["172.32.32.0/28","172.32.32.112/28"]
}
variable "private_subnets_cidr" {
  type = list(string)
  default = ["172.32.32.16/28","172.32.32.128/28"]
}
variable "key_name" {
  default = "cisco-ise-lab"
  description = "Name of the key pair created in AWS; used to SSH into the ISE nodes"
}
variable "ise_ami_apse2" {
  default = "ami-0f1846c9d911d1727"
}
variable "ise_instance_type_small" {
  default = "t3.xlarge"
}
variable "ise31_aws1_gig0_ip" {
  default = "172.32.32.24"
}
variable "ise31_aws2_gig0_ip" {
  default = "172.32.32.132"
}
/*
variable "tunnel1_psk" {
  default = "hAxVnrCPwsVC_4_yFqyaj8pM9m_2hGJA"
}
variable "tunnel2_psk" {
  default = "BOsGV4ZKY6DvRjroQ1x.3k8ORAtFmXA1"
}
variable "on_prem_gw_ip" {
  default = "159.196.180.166"
}
*/
