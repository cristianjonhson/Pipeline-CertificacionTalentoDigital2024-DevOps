# variables.tf

variable "image_name" {
  description = "El nombre de la imagen Docker"
  type        = string
  default     = "myapp"
}

variable "docker_port" {
  description = "Puerto que se expondrá en el contenedor"
  type        = number
  default     = 8080
}
