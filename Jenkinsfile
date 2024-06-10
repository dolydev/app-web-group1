pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
         SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {

        // Étape: Nettoyer l'espace de travail
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        //Etape : recuperer le code dans github
        stage('Checkout FROM GIT') {
            steps {
                // Cloner le dépôt de votre code source
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }

         // Étape: Analyse SonarQube
        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=site_greta \
                    -Dsonar.projectKey=site_greta '''
                }
            }
        }
          // Étape: Vérification de la qualité
        stage("Quality Gate Check") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
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
    
                    '''
                }
            }
        }

     
    }


}
