provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "dyallab" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "dyallab-key"

  tags = {
    Name = "dyallab-instance"
  }

  provisioner "local-exec" {
    command = "sh ./scripts/configure_instance.sh ${self.public_dns} ${var.USER}"
  }
}

resource "aws_key_pair" "dyallab-key" {
  key_name = "dyallab-key"
  public_key = var.AWS_PUBLIC_KEY
}

output "ec2_public_dns" {
  value = aws_instance.dyallab.public_dns
}
