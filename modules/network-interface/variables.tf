## Variables for Network Interface child module configuration

variable "subnet_id" {
  description = "Subnet ID for interface"
}
variable "private_ips" {
  type = list(any)
}
variable "security_groups" {
  type = list(any)
}
variable "tags" {
  type = map(string)
}

