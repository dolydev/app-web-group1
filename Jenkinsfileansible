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
                    withCredentials([string(credentialsId: 'SUDO_PASSWORD', variable: 'SUDO_PASS')]) {
                        def playbookPath = 'ansible/playbook-deploy-docker-compose.yml'
                        def inventoryPath = 'ansible/inventory.ini'
                        def user = 'dalila'
                        
                        // Check if the playbook exists
                        if (fileExists(playbookPath)) {
                            sh """
                            ansible-playbook -i ${inventoryPath} ${playbookPath} -u ${user} --extra-vars 'ansible_sudo_pass=${SUDO_PASS}' --ask-pass
                            """
                        } else {
                            error "Playbook ${playbookPath} not found"
                        }
                    }
                }
            }
        }
    }
}
