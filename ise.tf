
# Create network interface for ISE - AZ1
resource "aws_network_interface" "ise31aws1_gig0" {
  subnet_id       = aws_subnet.private_subnet[0].id
  private_ips     = [var.ise31_aws1_gig0_ip]
  security_groups = [aws_security_group.ise_network_access.id]
}
# Create network interface for ISE - AZ2
resource "aws_network_interface" "ise31aws2_gig0" {
  subnet_id       = aws_subnet.private_subnet[1].id
  private_ips     = [var.ise31_aws2_gig0_ip]
  security_groups = [aws_security_group.ise_network_access.id]
}

# Create two ISE instances in the private subnets

resource "aws_instance" "ise31aws1" {
  ami               = var.ise_ami_apse2
  availability_zone = var.iselab_az1
  instance_type     = var.ise_instance_type_small
  key_name          = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.ise31aws1_gig0.id
    device_index         = 0
  }
  tags = {
    "Name" = "ise31aws1"
  }
  user_data = file("./ise31aws1.txt")
  lifecycle {
    ignore_changes = [user_data]
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 300
    volume_type = "gp2"
  }
}

resource "aws_instance" "ise31aws2" {
  ami               = var.ise_ami_apse2
  availability_zone = var.iselab_az2
  instance_type     = var.ise_instance_type_small
  key_name          = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.ise31aws2_gig0.id
    device_index         = 0
  }
  tags = {
    "Name" = "ise31aws2"
  }
  user_data = file("./ise31aws2.txt")
    lifecycle {
    ignore_changes = [user_data]
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 300
    volume_type = "gp2"
  }
}
