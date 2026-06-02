pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                // --no-cache ensures Docker doesn't use the old files
                sh 'docker build --no-cache -t my-react-app:latest .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker rm -f my-running-app || true'
                sh 'docker run -d -p 8081:80 --name my-running-app my-react-app:latest'
            }
        }
    }
}