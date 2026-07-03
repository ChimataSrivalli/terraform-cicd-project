resource "aws_subnet" "public" {

  vpc_id = var.vpc_id

  cidr_block = var.public_subnet_cidr

  availability_zone = var.availability_zone

  map_public_ip_on_launch = true

  tags = {

    Name = "${var.project_name}-${var.environment}-public-subnet"

    Environment = var.environment

  }

}