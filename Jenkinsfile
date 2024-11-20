pipeline {
    agent any

    environment {
        TF_VERSION = '1.5.0'
    }

    stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Instalar Terraform si no está instalado
                    sh 'curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip'
                    sh 'unzip terraform_${TF_VERSION}_linux_amd64.zip'
                    sh 'mv terraform /usr/local/bin/'
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
