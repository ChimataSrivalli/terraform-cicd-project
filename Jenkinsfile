pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ChimataSrivalli/terraform-cicd-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                cd application
                docker build -t devops-app:latest .
                '''
            }
        }

        stage('Verify Kubernetes') {
            steps {
                sh '''
                kubectl get nodes
                kubectl get pods -A
                '''
            }
        }

        stage('GitOps') {
            steps {
                echo 'Argo CD will synchronize the repository automatically.'
            }
        }
    }
}
