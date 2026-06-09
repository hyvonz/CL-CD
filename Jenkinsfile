pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        IMAGE_NAME = 'cicd-demo'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        TEST_URL = 'http://localhost:18080/health'
        PROD_URL = 'http://localhost:28080/health'
        SMOKE_RETRIES = '10'
        SMOKE_INTERVAL = '2'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare') {
            steps {
                sh 'chmod +x scripts/ci/*.sh'
                sh './scripts/ci/check_toolchain.sh'
            }
        }

        stage('Unit Test') {
            steps {
                sh './scripts/ci/run_unit_tests.sh'
            }
        }

        stage('Docker Build') {
            steps {
                sh './scripts/ci/build_image.sh'
            }
        }

        stage('Deploy to Test') {
            steps {
                sh './scripts/ci/deploy_environment.sh test'
            }
        }

        stage('Smoke Test') {
            steps {
                sh './scripts/ci/smoke_test.sh test'
            }
        }

        stage('Deploy to Production') {
            steps {
                input message: 'Smoke test passed. Deploy to production?'
                sh './scripts/ci/deploy_environment.sh prod'
                sh './scripts/ci/smoke_test.sh prod'
            }
        }
    }

    post {
        always {
            sh './scripts/ci/show_deployment_state.sh || true'
        }
    }
}
