module "vpc" {

  source = "./modules/vpc"

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = var.vpc_cidr

}

module "subnet" {

  source = "./modules/subnet"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  public_subnet_cidr = var.public_subnet_cidr

  availability_zone = var.availability_zone

}
module "internet_gateway" {

  source = "./modules/internet-gateway"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

}
module "route_table" {

  source = "./modules/route-table"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  subnet_id = module.subnet.public_subnet_id

  internet_gateway_id = module.internet_gateway.internet_gateway_id

}
module "security_group" {

  source = "./modules/security-group"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

}
module "iam" {

  source = "./modules/iam"

  project_name = var.project_name

  environment = var.environment

}
module "ec2" {

  source = "./modules/ec2"

  project_name = var.project_name

  environment = var.environment

  instance_type = var.instance_type # t3.medium

  subnet_id = module.subnet.public_subnet_id

  security_group_id = module.security_group.security_group_id

  key_name = var.key_name

  iam_instance_profile = module.iam.instance_profile_name

  volume_size = var.volume_size

  volume_type = var.volume_type
}