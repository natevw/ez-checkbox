resource "aws_key_pair" "deployer" {
  key_name   = "${ var.deploy_prefix }deployer"
  public_key = data.local_file.ssh_key.content
}

data "local_file" "setup_script" {
  filename = "instance-setup.sh"
}

resource "aws_instance" "proxy_server" {
  ami           = data.aws_ami.debian.id
  key_name      = aws_key_pair.deployer.key_name
  instance_type = var.instance_type
  metadata_options {
    http_tokens = "required"
  }
  
  vpc_security_group_ids = [aws_security_group.sysadmin.id, aws_security_group.dns_host.id]
  availability_zone = var.aws_availzone
  
  user_data = data.local_file.setup_script.content
  
  tags = {
    Name = "${ var.deploy_prefix }box"
  }
}

output "ssh_user" {
  # ~HACK: log the hardcoded Debian default instance user as reminder…
  #  afaict this is *not* part of AMI/instance metadata.
  # see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html#ami-default-user-names
  # via https://stackoverflow.com/questions/20779454/how-to-find-the-username-of-the-instance-launched-in-amazon-ec2/67171575#67171575
  description = "Proxy host SSH user"
  value = "admin"
}

output "ssh_host" {
  description = "Proxy host instance"
  value = aws_instance.proxy_server.public_dns
}

output "host_ip" {
  description = "Proxy host public IPv4 address"
  value = aws_instance.proxy_server.public_ip
}
