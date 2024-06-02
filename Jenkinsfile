pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout your Ansible playbook repository
                git 'https://github.com/dolydev/app-web-group1.git'
            }
        }

        stage('Run Ansible playbook') {
            steps {
                script {
                    // Run your Ansible playbook
                    sh 'ansible-playbook -i inventory playbook.yml'
                }
            }
        }
    }
}
