pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_IMAGE_NAME = 'image-file-rouge'
        DOCKER_CONTAINER_NAME = 'site-greta'
        DOCKER_REGISTRY_URL = 'your-docker-registry-url'
        DOCKER_CREDENTIALS_ID = 'docker'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout FROM GIT') {
            steps {
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=site_greta \
                        -Dsonar.projectKey=site_greta
                    '''
                }
            }
        }

        stage("Quality Gate Check") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:latest", "-f Dockerfile .")
                }
            }
        }

        stage("Trivy Image Scan") {
            steps {
                sh "trivy image ${DOCKER_IMAGE_NAME}:latest > trivy.txt"
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            echo "\$DOCKER_PASSWORD" | docker login -u "\$DOCKER_USERNAME" --password-stdin
                            docker tag ${DOCKER_IMAGE_NAME}:latest \${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                            docker push \${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                            docker logout
                        """
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            docker run --name ${DOCKER_CONTAINER_NAME} -p 8000:80 -d \${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }
    stage('Run Docker Container in worker') {
            steps {
                sh '''
                    echo "Running script at the root of the project..."
                    ./serviceswarm.sh
                '''
            }
        }
      
      
    }
}
