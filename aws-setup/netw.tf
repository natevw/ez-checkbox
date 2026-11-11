resource "aws_default_vpc" "default" {}

resource "aws_security_group" "sysadmin" {
  name = "${ var.deploy_prefix }sysadmin"
  description = "General instance administration"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_egress_rule" "sysadmin_out" {
  security_group_id = aws_security_group.sysadmin.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "sysadmin_ssh" {
  security_group_id = aws_security_group.sysadmin.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "sysadmin_ping" {
  security_group_id = aws_security_group.sysadmin.id
  referenced_security_group_id = aws_security_group.sysadmin.id
  from_port = 8
  to_port = 0
  ip_protocol = "icmp"
}

resource "aws_security_group" "dns_host" {
  name = "${ var.deploy_prefix }dns_host"
  description = "Rules for gateway service itself"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "dns_host_access" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.dns_host.id
  from_port   = 53
  to_port = 53
  ip_protocol = "udp"
}
