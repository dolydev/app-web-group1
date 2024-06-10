#!/bin/bash

echo "Nom : $0"

echo "Téléchargement de l'image sur le nœud principal..."
docker pull dalila854/image-file-rouge:latest || { echo "Échec du téléchargement de l'image"; exit 1; }

echo "Téléchargement de l'image sur 192.168.176.129..."
ssh -o StrictHostKeyChecking=no user@192.168.176.129 "docker pull dalila854/image-file-rouge:latest" || { echo "Échec du téléchargement de l'image sur 192.168.176.129"; exit 1; }

echo "Création du service Docker..."
docker service create --name site-greta --replicas 1 --publish 80:80 dalila854/image-file-rouge:latest || { echo "Échec de la création du service"; exit 1; }

echo "Vérification de l'image sur tous les nœuds..."
docker service ps site-greta || { echo "Échec de la vérification du service"; exit 1; }
