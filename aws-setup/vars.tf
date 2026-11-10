variable "deploy_prefix" {
  type = string
  description = "Prefix added to object names"
  default = "ezcb_"
}

variable "allowed_ips" {
  type = list(string)
  description = "IP addresses allowed to use the DNS (in CIDR form)"
  default = ["0.0.0.0/32"]
}

data "local_file" "ssh_key" {
  filename = "bootstrap-key.pub"
}

variable "aws_region" {
  type = string
  description = "AWS region"
  default = "us-east-2"
}

variable "aws_availzone" {
  type = string
  description = "Availability zone within region"
  default = "us-east-2a"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type"
  default = "t4g.nano"
}

data "aws_ami" "debian" {
  # see https://wiki.debian.org/Cloud/AmazonEC2Image/Trixie
  filter {
    name = "name"
    values = ["debian-13-arm64-*"]
  }
  owners = ["136693071363"]
  most_recent = true
}
