#!/bin/bash

# Mettre à jour le système
sudo apt update -y

# Installer OpenJDK 17
sudo apt install openjdk-17-jdk -y

# Ajouter JAVA_HOME et mettre à jour PATH dans /etc/environment
if ! grep -q 'JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' /etc/environment; then
    echo 'JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' | sudo tee -a /etc/environment
fi

if ! grep -q 'PATH="$PATH:$JAVA_HOME/bin"' /etc/environment; then
    echo 'PATH="$PATH:$JAVA_HOME/bin"' | sudo tee -a /etc/environment
fi

# Appliquer les modifications sans redémarrer
source /etc/environment

# Vérifier l'installation
java --version
echo $JAVA_HOME
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo usermod -aG docker jenkins
#recuperer le password pour l'interface graphic
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
