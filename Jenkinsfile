pipeline {
    agent any

    environment {
        // حط الـ Jenkins credentials IDs المناسبة
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')      // ID للـ access key
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')  // ID للـ secret key
        AWS_DEFAULT_REGION    = 'us-east-1'  // غير الريجون حسب الحاجة
    }

    options {
        // يمنع أكثر من build شغال في نفس الوقت
        skipDefaultCheckout(true)
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('.') {  // لو main.tf في root
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('.') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('.') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('.') {
                    sh 'terraform fmt -check'
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
        success {
            echo "Terraform ran successfully."
        }
        failure {
            echo "Terraform pipeline failed!"
        }
    }
}
