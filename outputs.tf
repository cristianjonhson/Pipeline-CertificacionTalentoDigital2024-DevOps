# outputs.tf

# Salida del nombre de la imagen Docker creada
output "docker_image_name" {
  description = "El nombre de la imagen Docker creada"
  value       = docker_image.my_app_image.name
}

# Salida del puerto mapeado
output "container_port" {
  description = "El puerto externo del contenedor"
  value       = docker_container.my_app_container.ports[0].external
}
