pipeline {
    agent any

    environment {
        TF_VERSION = '1.5.0'
        TF_BIN_DIR = "${env.HOME}/bin"
    }

    stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Crear el directorio bin en el directorio HOME si no existe
                    sh 'mkdir -p $HOME/bin'
                    // Descargar Terraform
                    sh 'curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip'
                    // Descomprimir Terraform
                    sh 'unzip terraform_${TF_VERSION}_linux_amd64.zip'
                    // Mover terraform al directorio bin
                    sh 'mv terraform $TF_BIN_DIR/'
                    // Agregar terraform al PATH
                    sh 'export PATH=$TF_BIN_DIR:$PATH'
                }
            }
        }
        stage('Initialize Terraform') {
            steps {
                script {
                    // Inicializar Terraform
                    sh 'terraform init'
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
