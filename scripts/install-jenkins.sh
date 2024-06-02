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
