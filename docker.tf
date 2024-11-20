# Proveedor de Docker: Se define el proveedor para gestionar Docker desde Terraform
# En este caso, estamos utilizando el socket Unix de Docker en el sistema local
provider "docker" {
  host = "unix:///var/run/docker.sock"  # Dirección del socket de Docker en el sistema local
}

# Recurso de la imagen Docker: Define cómo se debe construir y etiquetar la imagen de Docker
resource "docker_image" "my_app_image" {
  name = "myapp"  # Nombre de la imagen Docker que se va a crear

  # Bloque de construcción de la imagen Docker
  build {
    context = "."  # El contexto es el directorio actual (donde se encuentra el Dockerfile)
  }
}

# Recurso del contenedor Docker: Define el contenedor que se va a ejecutar
resource "docker_container" "my_app_container" {
  image = docker_image.my_app_image.latest  # Usamos la última versión de la imagen creada previamente
  name  = "myapp"  # Nombre del contenedor Docker

  # Configuración de puertos: Exponemos el puerto 8080 del contenedor hacia el host
  ports {
    internal = 8080   # Puerto interno del contenedor (donde la aplicación escucha)
    external = 8080   # Puerto en el host que será mapeado al puerto interno
  }
}
