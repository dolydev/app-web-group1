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
        
    stage('Run Ansible playbook') {
            steps {
                script {
                    // Run your Ansible playbook
                    sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook-deploy-docker-compose.yaml -u dalila --ask-pass -K'
                }
            }
        }


        
     
    }


}
