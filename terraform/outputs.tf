output "project_name" {
  value = var.project_name
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}
output "public_subnet_id" {

  value = module.subnet.public_subnet_id

}
output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}
output "route_table_id" {
  value = module.route_table.route_table_id
}
output "security_group_id" {
  value = module.security_group.security_group_id
}
output "iam_instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "iam_role_name" {
  value = module.iam.iam_role_name
}
output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}