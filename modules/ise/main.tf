# ISE Module configuration

resource "aws_instance" "ise" {
  ami               = var.ami
  availability_zone = var.availability_zone
  instance_type     = var.instance_type
  key_name          = var.key_name
  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }
  tags = var.tags

  user_data = var.user_data
  lifecycle {
    ignore_changes = [user_data]
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volume_size
    volume_type = "gp2"
  }
}