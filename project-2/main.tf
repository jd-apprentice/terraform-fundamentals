terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

/*
* [READ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* Here we are setting up the provider for AWS, this is the service we are going to use to create our infrastructure.
* Remember to store your credentials in a safe place, in this case we are using the credentials of the root user, but it is recommended to create a user with the necessary permissions and use those credentials.
*/

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

/*
* We are creating a VPC (Virtual Private Cloud) which is a virtual network dedicated to your AWS account.
* [READ](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
*/

resource "aws_vpc" "dyallab_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production-vpc"
  }
}

/*
* We are creating an internet gateway which is a VPC component that allows communication between instances in your VPC and the internet.
* [READ](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
*/
resource "aws_internet_gateway" "dyallab_gw" {
  vpc_id = aws_vpc.dyallab_vpc.id

  tags = {
    Name = "production-gw"
  }
}

resource "aws_route_table" "dyallab_route_table" {
  vpc_id = aws_vpc.dyallab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dyallab_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dyallab_gw.id
  }

  tags = {
    Name = "production-route-table"
  }
}

resource "aws_subnet" "subnet_webserver" {
  vpc_id            = aws_vpc.dyallab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "production-subnet-webserver"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_webserver.id
  route_table_id = aws_route_table.dyallab_route_table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.dyallab_vpc.id

  // For everyone to access the web server
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    // Here you can specify the IP range you want to allow, in this case it is open to the world since it is a web server
    // If not we would use my IP address and the IP address of the other developers
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To allow SSH access to the web server
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // This means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

resource "aws_network_interface" "webserver" {
  subnet_id       = aws_subnet.subnet_webserver.id
  private_ip      = "10.0.1.50"
  security_groups = [aws_security_group.allow_web.id]
}

/*
* Elastic IP requires a internet gateway to be created, so we are using the internet gateway we created earlier.
*/
resource "aws_eip" "eip" {
  vpc               = true
  network_interface = aws_network_interface.webserver.id
  # associate_with_private_ip = "10.0.1.50" // Have to figure out how to associate with private IP
  depends_on = [aws_internet_gateway.dyallab_gw]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.dyallab_webserver.id
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_eip.eip]
}

/*
* Instances are just private computers at our disposal, in this case we are creating a web server.
*/
resource "aws_instance" "dyallab_webserver" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.zone

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.webserver.id
  }

  tags = {
    Name = "production-webserver"
  }
}

resource "aws_key_pair" "dyallab" {
  depends_on = [aws_instance.dyallab_webserver]
  public_key = file(var.ssh_key)
}
