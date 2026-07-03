pipeline {
    agent any

    environment {
        IMAGE_NAME = "devops-app"
        IMAGE_TAG = "1.0"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ChimataSrivalli/terraform-cicd-project.git'
            }
        }

        stage('Build Docker Image') {
    steps {
        sh '''
        cd application
        docker build -t devops-app:1.0 .
        '''
    }
}

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f kubernetes/namespace.yaml
                kubectl apply -f kubernetes/deployment.yaml
                kubectl apply -f kubernetes/service.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get pods -n devops
                kubectl get svc -n devops
                '''
            }
        }
    }
}
