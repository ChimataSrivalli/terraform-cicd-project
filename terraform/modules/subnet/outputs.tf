output "public_subnet_id" {

  description = "Public Subnet ID"

  value = aws_subnet.public.id

}