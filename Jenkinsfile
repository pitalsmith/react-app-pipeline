pipeline {
    agent any

    environment {
        // This special DNS name forces Jenkins to look outside itself and hit your local machine directly
        LOCALSTACK_ENDPOINT   = 'http://host.docker.internal:4566'
        BUCKET_NAME           = 'react-app-bucket'
    }

    stages {
        stage('Verify Downloaded Assets') {
            steps {
                echo 'Checking compiled distribution assets...'
                sh 'ls -la ./dist'
            }
        }

        stage('Deploy to Infrastructure') {
            steps {
                echo "Deploying production assets directly to LocalStack S3 bucket via REST API..."
                sh """
                    # 1. Create the bucket using a standard HTTP PUT request
                    curl -X PUT "${LOCALSTACK_ENDPOINT}/${BUCKET_NAME}" || echo "Bucket initialization processed."

                    # 2. Upload index.html
                    curl -X PUT -T ./dist/index.html "${LOCALSTACK_ENDPOINT}/${BUCKET_NAME}/index.html" -H "Content-Type: text/html"

                    # 3. Upload icons and svgs
                    curl -X PUT -T ./dist/favicon.svg "${LOCALSTACK_ENDPOINT}/${BUCKET_NAME}/favicon.svg" -H "Content-Type: image/svg+xml"
                    curl -X PUT -T ./dist/icons.svg "${LOCALSTACK_ENDPOINT}/${BUCKET_NAME}/icons.svg" -H "Content-Type: image/svg+xml"

                    # 4. Upload build assets inside the assets directory dynamically
                    if [ -d "./dist/assets" ]; then
                        for file in ./dist/assets/*; do
                            filename=\$(basename "\$file")
                            echo "Uploading asset: \$filename"
                            curl -X PUT -T "\$file" "${LOCALSTACK_ENDPOINT}/${BUCKET_NAME}/assets/\$filename"
                        done
                    fi
                """
            }
        }
    }
}