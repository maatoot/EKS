pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AWS_PROFILE = 'jenkins' // اسم profile لو عامل configure في /var/lib/jenkins/.aws/credentials
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maatoot/EKS.git'
            }
        }

        stage('Setup Terraform Backend') {
            steps {
                dir('terraform') { // لو ملفاتك في مجلد terraform
                    sh '''
                        mkdir -p .terraform
                        cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
EOF
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            dir('terraform') {
                sh 'terraform fmt'
            }
        }
        failure {
            echo 'Terraform failed!'
        }
        success {
            echo 'Terraform applied successfully!'
        }
    }
}
