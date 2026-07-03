output "instance_profile_name" {
  value = aws_iam_instance_profile.profile.name
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.profile.arn
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}