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

resource "aws_security_group" "nameserver_usage" {
  name = "${ var.deploy_prefix }nameserver_usage"
  description = "Rules for gateway service itself"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "nameserver_usage_dns" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.nameserver_usage.id
  from_port   = 53
  to_port = 53
  ip_protocol = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "nameserver_usage_dns_alt" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.nameserver_usage.id
  from_port   = 5353
  to_port = 5353
  ip_protocol = "udp"
}


resource "aws_security_group" "proxy_usage" {
  name = "${ var.deploy_prefix }proxy_usage"
  description = "Rules for gateway service itself"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "proxy_usage_http" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.proxy_usage.id
  from_port   = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "proxy_usage_https" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.proxy_usage.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "proxy_usage_http_alt" {
  for_each = toset(var.allowed_clients)
  cidr_ipv4 = each.value
  
  security_group_id = aws_security_group.proxy_usage.id
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
}
