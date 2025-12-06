pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = 'YOUR_ACCESS_KEY'
        AWS_SECRET_ACCESS_KEY = 'YOUR_SECRET_KEY'
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maatoot/EKS.git'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
            sh 'terraform fmt -check || true'
        }
        failure {
            echo 'Terraform pipeline failed!'
        }
    }
}
