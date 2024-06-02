pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
    }

    stages {
        stage('Checkout') {
            steps {
                // Cloner le dépôt de votre code source
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }
        
      
    }


}
