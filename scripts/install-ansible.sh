#!/bin/bash
#on exécute les mises à jour
sudo apt update && apt full-upgrade -y
#on installe les dépendances
sudo apt install ansible -y

ansible-galaxy collection install community.docker

