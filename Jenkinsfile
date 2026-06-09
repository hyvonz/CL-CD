pipeline {
    agent any

    environment {
        IMAGE_NAME = 'cicd-demo'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        TEST_URL = 'http://localhost:18080/health'
        PROD_URL = 'http://localhost:28080/health'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Test') {
            steps {
                sh 'python3 -m pip install --user -r app/requirements.txt'
                sh 'python3 -m pytest test'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Deploy to Test') {
            steps {
                sh 'IMAGE_TAG=${IMAGE_TAG} docker compose -f docker-compose.test.yml up -d'
            }
        }

        stage('Smoke Test') {
            steps {
                sh 'for i in 1 2 3 4 5; do curl --noproxy "*" -fsS ${TEST_URL} && exit 0; sleep 2; done; exit 1'
            }
        }

        stage('Deploy to Production') {
            steps {
                input message: 'Smoke test passed. Deploy to production?'
                sh 'IMAGE_TAG=${IMAGE_TAG} docker compose -f docker-compose.prod.yml up -d'
                sh 'for i in 1 2 3 4 5; do curl --noproxy "*" -fsS ${PROD_URL} && exit 0; sleep 2; done; exit 1'
            }
        }
    }

    post {
        always {
            sh 'docker ps --filter "name=cicd-demo"'
        }
    }
}
