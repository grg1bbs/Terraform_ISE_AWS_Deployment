
# Create network interface for ISE - AZ1
module "ise34aws1_gig0" {
  source          = "./modules/network-interface"
  subnet_id       = aws_subnet.private_subnet[0].id
  private_ips     = [var.ise_aws1_gig0_ip]
  security_groups = [aws_security_group.ise_network_access.id]
  tags = {
    Name = "ise34aws1_gig0"
  }
}

# Create network interface for ISE - AZ2
module "ise34aws2_gig0" {
  source          = "./modules/network-interface"
  subnet_id       = aws_subnet.private_subnet[1].id
  private_ips     = [var.ise_aws2_gig0_ip]
  security_groups = [aws_security_group.ise_network_access.id]
  tags = {
    Name = "ise34aws2_gig0"
  }
}

# Create ISE instance = AZ1
module "ise34aws1" {
  source = "./modules/ise"
  ami               = var.ise34_ami_apse2
  availability_zone = var.iselab_az1
  instance_type     = var.ise_instance_type_small
  key_name          = var.key_name
  network_interface_id = module.ise34aws1_gig0.private_ip.id
  volume_size = var.volume_size
  tags = {
    Name = "ise34aws1"
  }
  user_data = file("./ise34aws1.txt")
}

# Create ISE instance = AZ2
module "ise34aws2" {
  source = "./modules/ise"
  ami               = var.ise34_ami_apse2
  availability_zone = var.iselab_az2
  instance_type     = var.ise_instance_type_small
  key_name          = var.key_name
  network_interface_id = module.ise34aws2_gig0.private_ip.id
  volume_size = var.volume_size
  tags = {
    Name = "ise34aws2"
  }
  user_data = file("./ise34aws2.txt")
}
