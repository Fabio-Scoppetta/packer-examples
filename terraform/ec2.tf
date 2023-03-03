resource "aws_instance" "web" {
  ami           = data.aws_ami.web-server.id
  security_groups = [resource.aws_security_group.allow_http.id]
  instance_type = "t2.micro"
  tenancy       = "default"
  subnet_id = var.subnet_id
  tags = {
    Name = "web-server"
  }
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}