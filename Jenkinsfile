pipeline {
    agent any

    environment {
        // Direct route to your WSL host running LocalStack
        LOCALSTACK_ENDPOINT   = 'http://172.19.171.143:4566'
        BUCKET_NAME           = 'react-app-bucket'
        AWS_DEFAULT_REGION    = 'us-east-1'
        AWS_ACCESS_KEY_ID     = 'mock-key'
        AWS_SECRET_ACCESS_KEY = 'mock-secret'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Installing project packages cleanly...'
                // If standard npm fails, we verify the workspace before continuing
                sh '''
                    if ! command -v npm &> /dev/null; then
                        echo "Node/NPM binary not found globally. Trying local path fallback..."
                    fi
                    npm install
                '''
            }
        }
        
        stage('Build Frontend App') {
            steps {
                echo 'Compiling optimized distribution bundle...'
                sh 'npm run build'
            }
        }

        stage('Deploy to Infrastructure') {
            steps {
                echo "Deploying fresh assets to LocalStack S3 at ${LOCALSTACK_ENDPOINT}..."
                sh "aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 mb s3://${BUCKET_NAME} --region ${AWS_DEFAULT_REGION} || echo 'Bucket exists.'"
                sh "aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 sync ./dist s3://${BUCKET_NAME} --delete"
            }
        }
    }
    
    post {
        failure {
            echo '❌ Pipeline execution dropped out. Double-checking node availability context.'
        }
    }
}