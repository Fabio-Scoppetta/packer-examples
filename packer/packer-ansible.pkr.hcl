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
  name = "packer-ansible"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo \"Rodando o comando apt update\"",
      "sleep 3",
      "sudo apt-add-repository ppa:ansible/ansible",
      "sudo apt update 2>/dev/null",
      "echo \"instalando o ansible\"",
      "sleep 10",
      "sudo apt install -y ansible 2> /dev/null",
    ]
  }


  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
  }
}