pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'  // Set your AWS region
        ECR_REPOSITORY = 'my-app-repo'  // Your ECR repository name
        AWS_CREDENTIALS = 'aws'
        GITHUB_REPO = ''  // Your GitHub repository URL
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/SangeeArun1501/vanakkam-world.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-app-repo .'
                }
            }
        }
        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${AWS_CREDENTIALS}", usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY')]) {
                        // Authenticate Docker with AWS ECR
                        sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 396943898190.dkr.ecr.us-east-1.amazonaws.com
                        """
                    }
                }
            }
        }   
        stage('Push to AWS ECR') {
            steps {
                script {
                    sh "docker tag my-app-repo:latest 396943898190.dkr.ecr.us-east-1.amazonaws.com/my-app-repo:latest"
                    sh "docker push 396943898190.dkr.ecr.us-east-1.amazonaws.com/my-app-repo:latest"
                }
            }
        }
    }
}
