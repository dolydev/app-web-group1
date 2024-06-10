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

        // Étape: Nettoyer l'espace de travail
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        //Etape : recuperer le code dans github
        stage('Checkout FROM GIT') {
            steps {
                // Cloner le dépôt de votre code source
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }

         // Étape: Analyse SonarQube
        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=site_greta \
                    -Dsonar.projectKey=site_greta '''
                }
            }
        }
          // Étape: Vérification de la qualité
        stage("Quality Gate Check") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        // Étape: Analyse OWASP Dependency Check
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        // Étape: Analyse Trivy FS
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

         // Étape: Pousser l'image Docker vers Docker Hub
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

        
         // Étape: Construction de l'image Docker
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:latest", "-f Dockerfile .")
                }
            }
        }

        // Étape: Analyse Trivy de l'image Docker
        stage("Trivy Image Scan") {
            steps {
                sh "trivy image ${DOCKER_IMAGE_NAME}:latest > trivy.txt"
            }
        }
         // Étape: Exécution du conteneur Docker
        stage('Run Docker Container') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                        docker run --name ${DOCKER_CONTAINER_NAME} -p 8801:80 -d \${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }

     
    }


}
