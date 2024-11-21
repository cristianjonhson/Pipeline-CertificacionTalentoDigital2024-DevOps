# Proveedor de Docker: Se define el proveedor para gestionar Docker desde Terraform
# En este caso, estamos utilizando el socket Unix de Docker en el sistema local
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.25.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"  # Dirección del socket de Docker en el sistema local
}

# Recurso para construir la imagen Docker
resource "docker_image" "my_app_image" {
  name     = var.image_name  # Nombre de la imagen que se creará
  platform = "linux/amd64"   # Plataforma de la imagen

  # Bloque para construir la imagen
  build {
    context    = "."  # Contexto donde se encuentra el Dockerfile
    dockerfile = "./Dockerfile"  # Ruta al Dockerfile
  }
}

# Recurso para crear un contenedor desde la imagen construida
resource "docker_container" "my_app_container" {
  name  = var.image_name   # Nombre del contenedor

  # Usamos la imagen creada previamente
  image = docker_image.my_app_image.name  # Imagen construida en el paso anterior

  ports {
    internal = var.docker_port  # Puerto interno del contenedor
    external = var.docker_port  # Puerto que se expondrá en el host
  }
}
