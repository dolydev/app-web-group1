#!/bin/bash

# Variables
IMAGE_NAME="dalila854/image-file-rouge"# Nom de l'image Docker
IMAGE_TAG="latest" # Tag de l'image Docker
SERVICE_NAME="serviceswarm" # Nom du service Docker
PORT_MAPPING="8088:80" # Mappage de port pour le service Docker
WORKER_NODES=("192.168.176.129") # Liste des nœuds de travail

# Télécharger l'image sur chaque nœud
echo "Téléchargement de l'image sur le nœud principal..."
docker pull $IMAGE_NAME:$IMAGE_TAGo

for NODE in "${WORKER_NODES[@]}"; do
    echo "Téléchargement de l'image sur $NODE..."
    ssh vagrant@$NODE "docker pull $IMAGE_NAME:$IMAGE_TAG"
done

# Vérifier si le service existe déjà
SERVICE_EXISTS=$(docker service ls --filter name=$SERVICE_NAME -q)

if [ ! -z "$SERVICE_EXISTS" ]; then
    echo "Le service $SERVICE_NAME existe déjà. Suppression en cours..."
    docker service rm $SERVICE_NAME
    # Attendre que le service soit complètement supprimé
    sleep 10
fi

# Créer le service
echo "Création du service Docker..."
docker service create --name $SERVICE_NAME -p $PORT_MAPPING --replicas 1 $IMAGE_NAME:$IMAGE_TAG

# Vérifier si l'image est présente sur tous les nœuds
echo "Vérification de l'image sur tous les nœuds..."
echo "Nœud principal :"
docker images | grep $IMAGE_NAME
