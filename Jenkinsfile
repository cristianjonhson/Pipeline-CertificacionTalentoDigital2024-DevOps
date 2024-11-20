pipeline {
    agent any

    environment {
        TF_VERSION = '1.9.8'
        TF_BIN_DIR = "/var/jenkins_home/bin"
        TF_PATH = "${TF_BIN_DIR}/terraform"
       }  
   stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Crear el directorio bin en el directorio HOME si no existe
                    sh 'mkdir -p $TF_BIN_DIR'
                    // Descargar la versión correcta de Terraform (1.5.0)
                    sh "curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
                    // Descomprimir Terraform y mover al directorio bin
                    sh "unzip -o terraform_${TF_VERSION}_linux_amd64.zip -d $TF_BIN_DIR"
                    // Asegurarse de que la versión correcta de terraform esté en el PATH
                    sh "export PATH=$TF_BIN_DIR:$PATH"
                    // Verificar que terraform esté en el directorio correcto
                    sh "ls -la $TF_BIN_DIR"
                }
            }
        }

        stage('Verify Terraform Version') {
            steps {
                script {
                    // Verificar la versión de Terraform usando el binario recién instalado
                    def terraformVersion = sh(script: "$TF_PATH version -json", returnStdout: true).trim()
                    echo "Terraform version installed: ${terraformVersion}"
                    def expectedVersion = "v${TF_VERSION}"

                    // Compara las versiones
                    if (!terraformVersion.contains(expectedVersion)) {
                        error "Terraform version does not match the expected version: ${expectedVersion}. Found: ${terraformVersion}"
                    } else {
                        echo "Terraform version ${terraformVersion} matches the expected version."
                    }
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('Pipeline-CertificacionTalentoDigital2024-DevOps') {
                    script {
                        // Eliminar el archivo de bloqueo de dependencias
                        sh 'rm -f .terraform.lock.hcl'
                        // Inicializar Terraform
                        sh "$TF_PATH init -input=false"
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                 dir('Pipeline-CertificacionTalentoDigital2024-DevOps') {
                script {
                    // Aplicar la configuración de Terraform para crear la imagen y el contenedor Docker
                    sh "$TF_PATH apply -auto-approve"
                }
              }
            }
        }
    }
}
