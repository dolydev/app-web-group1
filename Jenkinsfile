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


     
    }


}
