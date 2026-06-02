pipeline {
    agent any

    environment {
        // Use the Docker container name instead of localhost
        LOCALSTACK_ENDPOINT = 'http://localstack:4566'
        BUCKET_NAME         = 'react-app-bucket'
        AWS_DEFAULT_REGION  = 'us-east-1'
        // Fake credentials required by AWS CLI to execute commands
        AWS_ACCESS_KEY_ID   = 'mock-key'
        AWS_SECRET_ACCESS_KEY = 'mock-secret'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Installing project packages securely...'
                // Clear out legacy locks and install fresh packages
                sh 'npm ci'
            }
        }

        stage('Build Frontend App') {
            steps {
                echo 'Compiling optimized distribution bundle...'
                // Build with standard relative/root target depending on your deployment
                sh 'npm run build'
            }
        }

        stage('Deploy to Infrastructure') {
            steps {
                echo "Validating S3 Bucket existence on LocalStack..."
                // Ensure bucket exists; if not, provision it on the fly
                sh """
                    aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 mb s3://${BUCKET_NAME} --region ${AWS_DEFAULT_REGION} || echo "Bucket already exists."
                """

                echo "Pushing fresh assets to S3..."
                // Synchronize static files down the pipeline
                sh """
                    aws --endpoint-url=${LOCALSTACK_ENDPOINT} s3 sync ./dist s3://${BUCKET_NAME} --delete
                """
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline execution completed! React App successfully deployed to LocalStack."
        }
        failure {
            echo "❌ Pipeline failed. Check terminal logs for environment or compilation blocks."
        }
    }
}