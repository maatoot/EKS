pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false -reconfigure'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan -input=false'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
        stage('Terraform Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    post {
        always {
            script {
                sh 'terraform fmt -check || true'
                echo "Pipeline finished!"
            }
        }
        failure {
            script {
                echo "Terraform pipeline failed!"
            }
        }
    }
}
