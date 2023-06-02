terraform {

  cloud {
    organization = "jd_apprentice"
    workspaces {
      name = "learn-tfc-aws"
    }
  }

}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

