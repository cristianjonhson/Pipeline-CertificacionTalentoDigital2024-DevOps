# variables.tf

# Definir una variable para el nombre de la imagen Docker (puede ser útil si deseas personalizarla)
variable "image_name" {
  description = "El nombre de la imagen Docker"
  type        = string
  default     = "myapp"  # Valor predeterminado
}

# Definir una variable para el puerto
variable "docker_port" {
  description = "Puerto que se expondrá en el contenedor"
  type        = number
  default     = 8082  # Puerto predeterminado
}
