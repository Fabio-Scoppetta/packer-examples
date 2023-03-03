data "aws_ami" web-server {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["web-server-*"]
  }

}

