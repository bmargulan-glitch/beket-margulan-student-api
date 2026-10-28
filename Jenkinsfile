// Declarative pipeline — Student API by Beket Margulan (it2-2302, ID 38109)
pipeline {
    agent any

    environment {
        STUDENT_NAME = 'Beket Margulan'
        IMAGE_NAME   = 'beket-margulan-student-api'
        IMAGE_TAG    = 'v1.0-beket-margulan-38109'
    }

    triggers {
        // Polling trigger: check GitHub every 2 minutes.
        // If you configure a GitHub webhook instead, you can remove this block.
        pollSCM('H/2 * * * *')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Pipeline started by student: ${STUDENT_NAME}"
                checkout scm
                sh 'git log -1 --oneline'
            }
        }

        stage('Build') {
            steps {
                echo "Building Spring Boot app for ${STUDENT_NAME}"
                sh 'chmod +x gradlew'
                sh './gradlew clean bootJar -x test --no-daemon'
            }
        }

        stage('Test') {
            steps {
                echo "Running automated tests for ${STUDENT_NAME}"
                // A failing test makes this step return non-zero, so the pipeline stops here
                sh './gradlew test --no-daemon'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'build/test-results/test/*.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}"
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    if docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} > /dev/null 2>&1; then
                        echo "Image ${IMAGE_NAME}:${IMAGE_TAG} exists"
                        docker images ${IMAGE_NAME}
                    else
                        echo "Image ${IMAGE_NAME}:${IMAGE_TAG} NOT found"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "SUCCESS: pipeline of ${STUDENT_NAME} finished, image ${IMAGE_NAME}:${IMAGE_TAG} is ready"
        }
        failure {
            echo "FAILURE: pipeline of ${STUDENT_NAME} failed — check the stage marked red"
        }
    }
}
