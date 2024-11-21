pipeline {
  agent any

  // Configuración del entorno con las variables necesarias para Terraform
  environment {
    TF_VERSION = '1.9.8' // Versión de Terraform que se desea instalar
    TF_BIN_DIR = "/var/jenkins_home/bin" // Directorio donde se almacenará el binario de Terraform
    TF_PATH = "${TF_BIN_DIR}/terraform" // Ruta completa al binario de Terraform
  }

  // Parámetros para personalizar el pipeline
  parameters {
    booleanParam(name: 'DESTROY_RESOURCES', defaultValue: false, description: 'Destroy Terraform resources after the build') // Controla si se destruyen los recursos al final
    booleanParam(name: 'INSTALL_TERRAFORM', defaultValue: true, description: 'Force reinstallation of Terraform') // Controla si se fuerza la instalación de Terraform
  }

  stages {

    stage('Clean Terraform Cache') {
      when {
        expression {
          params.INSTALL_TERRAFORM
        } // Solo ejecuta esta etapa si INSTALL_TERRAFORM es verdadero
      }
      steps {
        script {
          // Limpiar instalaciones previas de Terraform
          echo 'Cleaning previous Terraform installations...'
          sh "rm -f $TF_BIN_DIR/terraform" // Elimina el binario de Terraform si existe
          sh 'rm -rf ~/.terraform.d/' // Limpia configuraciones globales de Terraform (opcional)
        }
      }
    }

    stage('Install Terraform') {
      when {
        expression {
          params.INSTALL_TERRAFORM
        } // Solo instala Terraform si INSTALL_TERRAFORM es verdadero
      }
      steps {
        script {
          // Verifica si Terraform ya está instalado
          if (!fileExists("$TF_PATH")) {
            echo 'Installing Terraform...'
            sh ""
            "
            mkdir - p $TF_BIN_DIR // Crea el directorio si no existe
            curl - LO https: //releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip // Descarga el binario
              unzip - o terraform_$ {
                TF_VERSION
              }
            _linux_amd64.zip - d $TF_BIN_DIR // Descomprime el binario en el directorio destino
            rm terraform_$ {
              TF_VERSION
            }
            _linux_amd64.zip // Elimina el archivo ZIP descargado
            ""
            "
            echo 'Terraform installed successfully.'
          } else {
            // Mensaje si Terraform ya está instalado
            echo 'Terraform already installed.'
          }
        }
      }
    }

    stage('Verify Terraform Version') {
      steps {
        script {
          // Verifica la versión de Terraform instalada
          def terraformVersion = sh(script: "$TF_PATH version -json", returnStdout: true).trim()
          echo "Terraform version installed: ${terraformVersion}" // Muestra la versión instalada
        }
      }
    }

    stage('Configurar permisos de Docker') {
      steps {
        script {
          // Obtener el ID del contenedor
          def containerId = sh(script: "docker ps -qf 'ancestor=contenedor_jenkins-jenkins'", returnStdout: true).trim()

          // Validar si el contenedor existe
          if (containerId) {
            sh ""
            "
            docker exec - u root $ {
              containerId
            }
            /bin/sh - c '
            chown root: docker /
              var / run / docker.sock &&
              chmod 666 /
              var / run / docker.sock &&
              usermod - aG docker jenkins '
            ""
            "
          } else {
            error "No se encontró ningún contenedor basado en 'contenedor_jenkins-jenkins'."
          }
        }
      }
    }

    stage('Verify Docker Installation') {
      steps {
        script {
          try {
            // Verifica que Docker esté instalado y funcionando
            sh 'docker --version' // Muestra la versión de Docker
            sh 'docker ps' // Lista los contenedores en ejecución
          } catch (Exception e) {
            // Maneja errores si Docker no está disponible
            error "Docker is not properly installed or running. Details: ${e.message}"
          }
        }
      }
    }

    stage('Obtener ID del contenedor') {
      steps {
        script {
          // Obtener dinámicamente el ID del contenedor Jenkins
          CONTAINER_ID = sh(script: "docker ps -qf 'name=jenkins'", returnStdout: true).trim()
          echo "ID del contenedor obtenido: ${CONTAINER_ID}"
        }
      }
    }

    stage('Ejecutar comando en el contenedor') {
      steps {
        script {
          // Asegúrate de que el ID fue encontrado
          if (CONTAINER_ID) {
            sh "docker exec -it ${CONTAINER_ID} echo '¡Hola desde Jenkins!'"
          } else {
            error "No se pudo encontrar el contenedor con nombre 'jenkins'."
          }
        }
      }
    }

    stage('Force Provider Lock') {
      steps {
        dir('Pipeline-CertificacionTalentoDigital2024-DevOps') {
          script {
            // Bloquea las versiones de los proveedores de Terraform
            echo 'Forcing the download and lock of the provider...'
            sh "$TF_PATH providers lock -platform=linux_amd64" // Bloquea los proveedores para la arquitectura linux_amd64
          }
        }
      }
    }

    stage('Initialize Terraform') {
      steps {
        script {
          // Inicializa Terraform eliminando archivos de bloqueo anteriores
          sh 'rm -f .terraform.lock.hcl' // Elimina el archivo de bloqueo si existe
          sh "$TF_PATH init -input=false" // Ejecuta la inicialización de Terraform
        }
      }
    }

    stage('Plan Terraform Changes') {
      steps {
        // Crea el plan de ejecución de Terraform
        sh "$TF_PATH plan -out=tfplan -input=false" // Genera el plan y lo guarda en un archivo
      }
    }

    stage('Apply Terraform') {
      steps {
        script {
          // Aplica los cambios definidos en el plan de Terraform
          sh "$TF_PATH apply -auto-approve tfplan" // Aplica automáticamente sin pedir confirmación
        }
      }
    }

    stage('Destroy Terraform Resources') {
      when {
        expression {
          params.DESTROY_RESOURCES
        } // Solo ejecuta esta etapa si DESTROY_RESOURCES es verdadero
      }
      steps {
        script {
          // Destruye los recursos creados por Terraform
          sh "$TF_PATH destroy -auto-approve" // Elimina automáticamente los recursos
        }
      }
    }
  }

  // Bloques post para acciones al final de la ejecución
  post {
    always {
      // Mensaje que siempre se muestra al final de la ejecución
      echo 'Pipeline execution completed.'
    }
    success {
      // Mensaje que se muestra si la ejecución fue exitosa
      echo 'Terraform applied successfully.'
    }
    failure {
      // Mensaje que se muestra si la ejecución falló
      echo 'Pipeline failed. Check the logs for more details.'
    }
  }
}
