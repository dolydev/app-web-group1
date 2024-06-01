pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
    }

    stages {
        stage('Checkout') {
            steps {
                // Cloner le dépôt de votre code source
                git branch: 'main', url: 'https://github.com/dolydev/projet-devops-greta78.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Construire les images Docker définies dans le fichier docker-compose.yml
                    sh 'docker-compose -f $DOCKER_COMPOSE build'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Déployer les conteneurs Docker en arrière-plan
                    sh 'docker-compose -f $DOCKER_COMPOSE up -d'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Ajoutez ici vos scripts de test
                    // Par exemple, vous pouvez exécuter des tests HTTP pour vérifier que le serveur web est en cours d'exécution
                    sh '''
                    echo "Waiting for services to be ready..."
                    sleep 30
                    echo "Testing PHP container..."
                    curl -f http://localhost:8000 || exit 1
                    echo "Testing phpMyAdmin..."
                    curl -f http://localhost:8899 || exit 1
                    echo "Testing Prometheus..."
                    curl -f http://localhost:9090 || exit 1
                    echo "Testing Grafana..."
                    curl -f http://localhost:3000 || exit 1
                    '''
                }
            }
        }

     
    }


}
