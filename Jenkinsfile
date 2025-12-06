pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key')     // AWS Access Key Credential ID
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')    // AWS Secret Key Credential ID
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/maatoot/EKS.git', branch: 'main'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh 'terraform init -input=false'
                sh 'terraform destroy -auto-approve'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            sh 'terraform fmt -check'
            echo "Terraform pipeline finished!"
        }
        failure {
            echo "Terraform pipeline failed!"
        }
    }
}
