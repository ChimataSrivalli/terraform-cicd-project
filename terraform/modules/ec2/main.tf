data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
resource "aws_instance" "devops" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type # t3.medium

  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  key_name = var.key_name

  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size # 20 GB
    volume_type = var.volume_type
  }

 user_data = file("${path.module}/../../user_data/user_data.sh")

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }
}
