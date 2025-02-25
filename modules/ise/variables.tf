## Variables for ISE child module configuration

variable "ami" {
  description = "AMI ID for the ISE EC2 instance"
}
variable "availability_zone" {
  description = "AZ for ISE instance"
}
variable "instance_type" {
  description = "ISE EC2 instance type"
  default = "t3.xlarge"
}
variable "key_name" {
  description = "Name of the key pair created in AWS; used to SSH into the ISE nodes"
}
variable "network_interface_id" {
  description = "Network Interface ID"
}
variable "tags" {
  type = map(string)
}
variable "user_data" {
  description = "User Data for ISE setup"
}
variable "volume_size" {
  description = "Volume size for ISE disk"
}