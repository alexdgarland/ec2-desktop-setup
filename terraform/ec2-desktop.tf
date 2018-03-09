
provider "aws" {
  region     = "eu-west-2"
}

resource "aws_security_group" "ec2-desktop-group" {
  name        = "ec2-desktop-group"
  description = "Allow incoming SSH traffic"
  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_desktop" {
  ami           = "ami-941e04f0"
  instance_type = "t2.micro"
  security_groups = ["ec2-desktop-group"]
  key_name = "${var.ec2-keypair-name}"
  provisioner "local-exec" {
    command = "bash local_ssh_config.sh ${aws_instance.ec2_desktop.public_dns} ${var.ec2-keypair-name} | tee ~/.ssh/config"
  }
}
