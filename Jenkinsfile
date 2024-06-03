pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
        DOCKER_IMAGE_NAME = 'dalila854/app-web-group1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    // Utiliser le scanner SonarQube configuré dans Jenkins
                    sh '''
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=app-web-group1 \
                        -Dsonar.projectName=app-web-group1 \
                        -Dsonar.sources=./php \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: true, credentialsId: 'Sonar-token'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                script {
                    dependencyCheck additionalArguments: '--scan . --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                script {
                    sh "trivy fs . > trivyfs.txt"
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t $DOCKER_IMAGE_NAME ."
                        sh "docker push $DOCKER_IMAGE_NAME:latest"
                    }
                }
            }
        }

        stage('TRIVY Image Scan') {
            steps {
                script {
                    sh "trivy image $DOCKER_IMAGE_NAME:latest > trivy.txt"
                }
            }
        }

        stage('Deploy to container') {
            steps {
                sh 'docker-compose -f $DOCKER_COMPOSE up -d'
            }
        }

        stage('Test Deployment') {
            steps {
                script {
                    // Attendre que les services soient prêts
                    sleep 30

                    // Test du conteneur déployé
                    sh 'curl -v http://localhost:8000'
                }
            }
        }
    }
}
