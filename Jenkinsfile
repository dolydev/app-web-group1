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
        
 
        stage('Verify Workspace') {
            steps {
                sh 'pwd'
                sh 'ls -la'
                sh 'ls -la ansible'
            }
        }
        stage('Run Ansible playbook') {
            when {
                not { failed() }
            }
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook-deploy-docker-compose.yaml -u dalila --ask-pass -K'
            }
        }


        
     
    }


}
