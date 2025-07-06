resource "aws_instance" "first_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.security_group_web_access.id, aws_security_group.security_group_ssh_access.id]

  user_data = <<EOF
           #!/bin/bash
           yum install -y nginx
           systemctl start nginx
           echo "<h1>Hello, World!</h1>" > /usr/share/nginx/html/index.html
         EOF
}

resource "aws_security_group" "security_group_web_access" {
  name        = "security group for ec2 web access"
  description = "Allow HTTP/HTTPS access to web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "security_group_ssh_access" {
  name        = "security group for ec2 ssh access"
  description = "Allow SSH access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "my-key-pair"
  public_key = file("/Users/bushrafatima/.ssh/my-key-pair.pub")
}