terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "dolar-hoy-api" {
  name         = "dyallo/dolar-hoy-api:latest"
  keep_locally = false
}

resource "docker_container" "dolar-hoy-api" {
  image = docker_image.dolar-hoy-api.name
  name  = "dolar-hoy-api"
  ports {
    internal = var.PORT
    external = var.PORT
  }

  env = [
    "HOST=${var.HOST}",
    "USERNAME=${var.USERNAME}",
    "PASSWORD=${var.PASSWORD}",
    "DATABASE=${var.DATABASE}",
    "MANUAL_USERNAME=${var.MANUAL_USERNAME}",
    "MANUAL_PASSWORD=${var.MANUAL_PASSWORD}",
  ]
}
