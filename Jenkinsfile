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

        stage("Docker Build & Push") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t $DOCKER_IMAGE_NAME ."
                        sh "docker push $DOCKER_IMAGE_NAME:latest"
                    }
                }
            }
        }

        stage("TRIVY Image Scan") {
            steps {
                script {
                    sh "trivy image $DOCKER_IMAGE_NAME:latest > trivy.txt"
                }
            }
        }
        stage('Deploy to container'){
           steps {
                script {
                    // Arrêter et supprimer tout conteneur en cours d'exécution avec le même nom
                    sh 'docker stop app-web-group1 || true && docker rm app-web-group1 || true'
                    
                    // Déployer le conteneur
                    sh 'docker run -d --name app-web-group1 -p 8000:80 $DOCKER_IMAGE_NAME:latest'
                }
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
