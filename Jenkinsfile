pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = 'docker-compose.yaml'
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dolydev/app-web-group1.git'
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                script {
                    dependencyCheck additionalArguments: '--scan . --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                script {
                    sh "trivy fs . > trivyfs.txt"
                }
            }
        }

        stage('Deploy to container') {
            steps {
                sh 'docker-compose -f $DOCKER_COMPOSE up -d'
            }
        }

        stage('Test Deployment') {
            steps {
                script {
                    // Attendre que les services soient prêts
                    sleep 30

                    // Test du conteneur déployé
                    sh 'curl -v http://localhost:80'
                }
            }
        }

        stage('Prometheus Metrics') {
            steps {
                script {
                    // Test de la connexion à Prometheus
                    sh 'curl -v http://localhost:9090'
                }
            }
        }

        stage('Check Services') {
            steps {
                script {
                    sh 'docker-compose run --rm curl curl -v http://cadvisor:8081/metrics'
                    sh 'docker-compose run --rm curl curl -v http://php82:80/metrics'
                    sh 'docker-compose run --rm curl curl -v http://mysql-exporter:9104/metrics'
                }
            }
        }

        stage('Grafana Setup') {
            steps {
                script {
                    // Configuration initiale de Grafana (si nécessaire)
                    sh '''
                    echo "Setup Grafana"
                    '''
                }
            }
        }
    }
}
