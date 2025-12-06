pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key')     // ID credential بتاع الـ access key
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')     // ID credential بتاع الـ secret key
        AWS_DEFAULT_REGION    = 'us-east-1'
        TERRAFORM_DIR         = 'terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/maatoot/EKS.git', branch: 'main'
            }
        }

        stage('Terraform Destroy') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init -input=false'
                    sh 'terraform destroy -auto-approve'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            dir("${TERRAFORM_DIR}") {
                sh 'terraform fmt -check'
            }
            echo "Terraform pipeline finished!"
        }
        failure {
            echo "Terraform pipeline failed!"
        }
    }
}
