pipeline {
    agent any

    environment {
        DOCKER_STACK_NAME = 'app-stack'
        DOCKER_IMAGE_NAME = 'dalila854/app-web-group1'
        DOCKER_COMPOSE = 'docker-compose.yaml'
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }
     
        stage('Trivy FS Scan') {
            steps {
                // Votre étape Trivy FS Scan ici
            }
        }

        
        stage('TRIVY Image Scan') {
            steps {
                // Votre étape TRIVY Image Scan ici
            }
        }

        stage('Deploy to container') {
            steps {
                script {
                    // Déployer l'application sur Docker Swarm
                    sh "docker stack deploy -c $DOCKER_COMPOSE $DOCKER_STACK_NAME"
                }
            }
        }

        stage('Test Deployment') {
            steps {
                script {
                    // Attendre que les services soient prêts
                    sleep 30

                    // Test du déploiement
                    sh 'curl -v http://localhost:8000'
                }
            }
        }
    }
}
