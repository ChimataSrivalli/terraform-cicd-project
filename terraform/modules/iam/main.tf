resource "aws_iam_role" "ec2_role" {

  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "admin_access" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}
resource "aws_iam_instance_profile" "profile" {

  name = "${var.project_name}-${var.environment}-profile"

  role = aws_iam_role.ec2_role.name

}