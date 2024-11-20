# Proveedor de Docker: Se define el proveedor para gestionar Docker desde Terraform
# En este caso, estamos utilizando el socket Unix de Docker en el sistema local
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.25.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"  # Dirección del socket de Docker en el sistema local
}

# Recurso de la imagen Docker personalizada: Construir la imagen desde el Dockerfile
resource "docker_image" "my_app_image" {
  name     = var.image_name  # Usamos la variable 'image_name' para nombrar la imagen Docker
  platform = "linux/amd64"   # Especifica que la plataforma debe ser linux/amd64

  # Bloque de construcción de la imagen Docker usando el Dockerfile
  build {
    context = "."  # El contexto es el directorio actual (donde se encuentra el Dockerfile)
    dockerfile = "./Dockerfile"  # Especificamos la ubicación del Dockerfile
  }
}

# Recurso del contenedor Docker: Define el contenedor que se va a ejecutar a partir de la imagen creada
resource "docker_container" "my_app_container" {
  image = docker_image.my_app_image.name  # Usamos la última versión de la imagen creada previamente
  name  = var.image_name  # Usamos la variable 'image_name' para el nombre del contenedor

  # Configuración de puertos: Exponemos el puerto 8082 del contenedor hacia el host
  ports {
    internal = var.docker_port   # Usamos la variable 'docker_port' para el puerto interno
    external = var.docker_port   # Usamos la misma variable para el puerto externo
  }
}
