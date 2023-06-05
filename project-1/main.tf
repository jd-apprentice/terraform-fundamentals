terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "docker" {}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "dyallab" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "dyallab-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull dyallo/dolar-hoy-api:latest",
      "docker run -d --name dolar-hoy-api -p ${var.PORT}:${var.PORT} -e HOST=${var.HOST} -e USERNAME=${var.USERNAME} -e PASSWORD=${var.PASSWORD} -e DATABASE=${var.DATABASE} -e MANUAL_USERNAME=${var.MANUAL_USERNAME} -e MANUAL_PASSWORD=${var.MANUAL_PASSWORD} dyallo/dolar-hoy-api:latest",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /scripts/install-nginx.sh",
      "sh /scripts/install-nginx.sh",
      "sudo systemctl start nginx"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cat <<EOF > /etc/nginx/sites-available/dolar.jonathan.com.ar",
      "server {",
      "    server_name dolar.jonathan.com.ar;",
      "",
      "    location / {",
      "        proxy_pass http://localhost:4500;",
      "        proxy_http_version 1.1;",
      "        proxy_set_header Upgrade $http_upgrade;",
      "        proxy_set_header Connection 'upgrade';",
      "        proxy_set_header Host $host;",
      "        proxy_cache_bypass $http_upgrade;",
      "    }",
      "}",
      "EOF",
      "ln -s /etc/nginx/sites-available/dolar.jonathan.com.ar /etc/nginx/sites-enabled/dolar.jonathan.com.ar",
      "nginx -s reload",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /scripts/install-certbot.sh",
      "sh /scripts/install-certbot.sh",
      "certbot --nginx -n -d dolar.jonathan.com.ar --agree-tos --email contacto@jonathan.com.ar --no-eff-email"
    ]
  }
}



