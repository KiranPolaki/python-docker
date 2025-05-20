pipeline {
    agent any
    
    environment {
        // Define environment variables
        DOCKER_HUB_REPO = "your-dockerhub-username/your-repo-name"
        IMAGE_NAME = "${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Check out code from your repository
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${IMAGE_NAME} ."
                    
                    // Also tag as latest
                    sh "docker tag ${IMAGE_NAME} ${DOCKER_HUB_REPO}:latest"
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // Run any tests on the Docker image
                    sh "docker run --rm ${IMAGE_NAME} python -m pytest"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub and push the image
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        sh "docker push ${IMAGE_NAME}"
                        sh "docker push ${DOCKER_HUB_REPO}:latest"
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    // Remove local Docker images to save space
                    sh "docker rmi ${IMAGE_NAME}"
                    sh "docker rmi ${DOCKER_HUB_REPO}:latest"
                    sh "docker logout"
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline completed successfully! Docker image is now available at ${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
        }
        failure {
            echo "Pipeline failed! Check the logs for details."
        }
    }
}
