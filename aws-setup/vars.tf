variable "deploy_prefix" {
  type = string
  description = "Prefix added to object names"
  default = "ezcb_"
}

variable "allowed_clients" {
  type = list(string)
  description = "IP addresses allowed to use the DNS (in CIDR form)"
  default = ["0.0.0.0/32"]
}

variable "upstream_host" {
  type = string
  description = "Host which clients will connect to through us"
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

data "aws_ami" "base_os" {
  # see https://wiki.debian.org/Cloud/AmazonEC2Image/Trixie
  filter {
    name = "name"
    values = ["debian-13-arm64-*"]
  }
  owners = ["136693071363"]
  most_recent = true
}

locals {
  # ~HACK: afaict this is *not* part of AMI/instance metadata.
  # see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html#ami-default-user-names
  # via https://stackoverflow.com/questions/20779454/how-to-find-the-username-of-the-instance-launched-in-amazon-ec2/67171575#67171575
  ami_login_user = "admin"
}
