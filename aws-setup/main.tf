resource "aws_key_pair" "deployer" {
  key_name   = "${ var.deploy_prefix }deployer"
  public_key = data.local_file.ssh_key.content
}

resource "aws_instance" "proxy_server" {
  ami           = data.aws_ami.base_os.id
  key_name      = aws_key_pair.deployer.key_name
  instance_type = var.instance_type
  metadata_options {
    http_tokens = "required"
  }
  
  vpc_security_group_ids = [aws_security_group.sysadmin.id, aws_security_group.dns_host.id]
  availability_zone = var.aws_availzone
  
  tags = {
    Name = "${ var.deploy_prefix }box"
  }
  
  connection {
    agent = true
    host = self.public_dns
    user = local.ami_login_user
    #agent_identity = replace(data.local_file.ssh_key.filename, "/.pub$/", "")
  }
  
  provisioner "remote-exec" {
    script = "instance-setup.sh"
  }
}

output "ssh_user" {
  
  description = "Proxy host SSH user"
  value = local.ami_login_user
}

output "ssh_host" {
  description = "Proxy host instance"
  value = aws_instance.proxy_server.public_dns
}

output "host_ip" {
  description = "Proxy host public IPv4 address"
  value = aws_instance.proxy_server.public_ip
}
