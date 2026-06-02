pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build the image using the Dockerfile we perfected
                sh 'docker build -t my-react-app:latest .'
            }
        }
        
        stage('Deploy') {
            steps {
                // Stop and remove the existing container if it exists
                sh 'docker rm -f my-running-app || true'
                
                // Start the new container
                sh 'docker run -d -p 8081:80 --name my-running-app my-react-app:latest'
            }
        }
    }
}