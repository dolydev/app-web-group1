#!/bin/bash

# Script d'installation de Jenkins et Kubernetes

# Métadonnées
# Titre: Script d'installation Jenkins et Kubernetes
# Auteur: Goumal221
# Date de création: 2024-02-25
# Date de modification: 2024-02-29

# Mettre à jour le système
sudo apt update && sudo apt full-upgrade -y > /dev/null

# Configuration du hostname (commenté, à décommenter si nécessaire)
# sudo hostnamectl set-hostname master

# Ajout de l'utilisateur au groupe sudo
sudo usermod -aG sudo dalila

# Ajout de l'utilisateur au fichier sudoers
echo "dalila ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

# Installer des paquets nécessaires
sudo apt install -y curl apt-transport-https gnupg2 software-properties-common ca-certificates

# Ajouter la clé GPG et le dépôt Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Mettre à jour les dépôts
sudo apt update

# Installer les éléments pour gérer le cluster
sudo apt install -y wget git kubelet kubeadm kubectl

# Empêcher la suppression automatique d'un des paquets
sudo apt-mark hold kubelet kubeadm kubectl

# Vérifier l'installation des paquets
kubectl version --output=yaml
kubeadm version

# Désactiver le swap
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab

# Configurer les modules du kernel
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Ajouter des paramètres sysctl pour Kubernetes
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Recharger la configuration sysctl
sudo sysctl --system

# Ajouter la clé GPG et le dépôt Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Mettre à jour les dépôts
sudo apt update

# Installer Docker
sudo apt install -y containerd.io docker-ce docker-ce-cli

# Configurer Docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Recharger et redémarrer Docker
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

# Récupérer la version de cri-dockerd
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//g')

# Télécharger et extraire cri-dockerd
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz

# Déplacer cri-dockerd vers le dossier des binaires
sudo mv cri-dockerd/cri-dockerd /usr/local/bin/

# Vérifier l'installation de cri-dockerd
cri-dockerd --version

# Télécharger et configurer les fichiers de service systemd pour cri-dockerd
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket

sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

# Recharger et démarrer les services cri-dockerd
sudo systemctl daemon-reload 
sudo systemctl enable cri-docker.service 
sudo systemctl enable --now cri-docker.socket

# Vérifier le statut du socket cri-dockerd
sudo systemctl status cri-docker.socket

# Activer kubelet au démarrage
sudo systemctl enable kubelet

# Télécharger les images nécessaires pour Kubernetes
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock

# Initialiser le cluster Kubernetes
sudo kubeadm init --cri-socket unix:///run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16

# Configurer kubectl pour l'utilisateur non root
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
