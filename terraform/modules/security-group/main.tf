resource "aws_security_group" "this" {

  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for CI/CD stack"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 22

  to_port = 22

  ip_protocol = "tcp"

}
resource "aws_vpc_security_group_ingress_rule" "http" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 80

  to_port = 80

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "https" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 443

  to_port = 443

  ip_protocol = "tcp"

}
resource "aws_vpc_security_group_ingress_rule" "jenkins" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 8080

  to_port = 8080

  ip_protocol = "tcp"

}
resource "aws_vpc_security_group_ingress_rule" "grafana" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 3000

  to_port = 3000

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "prometheus" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 9090

  to_port = 9090

  ip_protocol = "tcp"

}
resource "aws_vpc_security_group_ingress_rule" "k8s_nodeports" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 30000

  to_port = 32767

  ip_protocol = "tcp"

}
resource "aws_vpc_security_group_egress_rule" "all" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}