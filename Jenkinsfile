pipeline {
    agent any

    environment {
        AWS_REGION       = 'us-east-1'
        S3_BUCKET        = 'my-terraform-state-bucket'   
        DYNAMO_TABLE     = 'terraform-lock-table'        
        TERRAFORM_DIR    = 'terraform'                   // المجلد اللي فيه ملفات tf
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/maatoot/EKS.git', branch: 'main'
            }
        }

        stage('Setup Terraform Backend') {
            steps {
                script {
                    sh """
                    mkdir -p ${TERRAFORM_DIR}
                    cat > ${TERRAFORM_DIR}/backend.tf <<EOL
                    terraform {
                      backend "s3" {
                        bucket         = "${S3_BUCKET}"
                        key            = "terraform.tfstate"
                        region         = "${AWS_REGION}"
                        dynamodb_table = "${DYNAMO_TABLE}"
                        encrypt        = true
                      }
                    }
                    EOL
                    """
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
                    input message: "Apply Terraform changes?"
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            dir("${TERRAFORM_DIR}") {
                sh 'terraform fmt'
            }
        }
        success {
            echo 'Terraform applied successfully!'
        }
        failure {
            echo 'Terraform failed!'
        }
    }
}
