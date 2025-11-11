pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        AWS_ACCOUNT_ID = '279427096273'
        ECR_REPO = 'dockerproject'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG = "v${BUILD_NUMBER}"
        DOCKER_IMAGE = "${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '🔹 Checking out source code from GitHub...'
                git credentialsId: 'dockerhub-credentials', url: 'https://github.com/praneeth2216/docker.git', branch: 'main'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo "🔹 Building Docker image: ${DOCKER_IMAGE}"
                    def dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    echo '🔹 Logging in to Amazon ECR...'
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} \
                        | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    '''
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    echo '🔹 Pushing image to ECR...'
                    sh '''
                    docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up local Docker images...'
                sh '''
                docker rmi ${DOCKER_IMAGE} || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and Push Successful!"
            echo "✅ Image available at: ${DOCKER_IMAGE}"
        }
        failure {
            echo "❌ Build Failed! Please check Jenkins logs for details."
        }
    }
}
