pipeline {
    agent any

    environment {
        LOCALSTACK_ENDPOINT   = 'http://172.19.171.143:4566'
        BUCKET_NAME           = 'react-app-bucket'
        AWS_DEFAULT_REGION    = 'us-east-1'
        AWS_ACCESS_KEY_ID     = 'mock-key'
        AWS_SECRET_ACCESS_KEY = 'mock-secret'
    }

    stages {
        stage('Verify Downloaded Assets') {
            steps {
                echo 'Checking compiled distribution assets from GitHub repository...'
                sh 'ls -la ./dist'
            }
        }

        stage('Deploy to Infrastructure') {
            steps {
                echo "Deploying production build assets directly to LocalStack S3 at ${LOCALSTACK_ENDPOINT}..."
                
                // Ensure target bucket exists inside LocalStack instance
                sh "aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 mb s3://${BUCKET_NAME} --region ${AWS_DEFAULT_REGION} || echo 'Bucket exists.'"
                
                // Sync static assets
                sh "aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 sync ./dist s3://${BUCKET_NAME} --delete"
            }
        }
    }
}