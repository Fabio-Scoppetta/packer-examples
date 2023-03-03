packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "web-server-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "primeira-imagem"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]


  provisioner "shell" {
    environment_vars = [
      "ACADEMY=packer",
      "VERSION=v1"
    ]
    inline = [
      "echo \"Rodando o comando apt update and upgrade\"",
      "sleep 3",
      "sudo apt update && sudo apt upgrade -y",
      "echo \"instalando o apache\"",
      "sleep 10",
      "sudo apt install -y apache2",
      "sudo echo \"scopes app Version $VERSION\" > scopes.html ; sudo cp scopes.html /var/www/html/index.html",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
    ]
  }
}