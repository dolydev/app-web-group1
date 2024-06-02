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
           
            steps {
                script {
                    def playbookPath = 'ansible/playbook-deploy-docker-compose.yml'
                    def inventoryPath = 'ansible/inventory.ini'
                    def user = 'dalila'

                    // Check if the playbook exists
                    if (fileExists(playbookPath)) {
                        sh "ansible-playbook -i ${inventoryPath} ${playbookPath} -u ${user} --ask-pass -K"
                    } else {
                        error "Playbook ${playbookPath} not found"
                    }
                }
            }
        }
      
    }


}
