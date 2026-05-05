pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kerenv25/java-maven-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build JAR') {
            steps {
                echo "Building JAR with Maven..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing to Docker Hub..."
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo "Deploying to EKS..."
                sh "sed -i 's|${DOCKER_IMAGE}:.*|${DOCKER_IMAGE}:${IMAGE_TAG}|g' deployment.yaml"
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
                sh "kubectl rollout status deployment/java-maven-app --timeout=120s"
            }
        }
    }

    post {
        success {
            echo "Build #${BUILD_NUMBER} deployed successfully."
        }
        failure {
            echo "Build #${BUILD_NUMBER} failed."
        }
    }
}
