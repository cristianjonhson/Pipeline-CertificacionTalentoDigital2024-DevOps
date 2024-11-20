pipeline {
    agent any

    environment {
        TF_VERSION = '1.9.8'
        TF_BIN_DIR = "${env.HOME}/bin"
    }

    tools {
        terraform 'terraform1'
    }

    stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Crear el directorio bin en el directorio HOME si no existe
                    sh 'mkdir -p $HOME/bin'
                    // Descargar Terraform
                    sh 'curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip'
                    // Descomprimir Terraform con la opción -o para sobrescribir sin preguntar, y Mover terraform al directorio bin
                    sh 'unzip -o terraform_${TF_VERSION}_linux_amd64.zip -d $TF_BIN_DIR'
                    // Agregar terraform al PATH
                    sh 'export PATH=$TF_BIN_DIR:$PATH'
                }
            }
        }

        stage('Verify Terraform Version') {
            steps {
                script {
                    // Verificar la versión de Terraform instalada
                    def terraformVersion = sh(script: 'terraform version -json', returnStdout: true).trim()
                    def expectedVersion = "v${TF_VERSION}"
                    
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
                        sh 'terraform init -input=false'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Aplicar la configuración de Terraform para crear la imagen y el contenedor Docker
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
