#!/bin/bash
set -e  # Encerra o script em caso de erro

# Atualiza pacotes e instala dependências
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# Cria diretório para chaves GPG
sudo install -m 0755 -d /etc/apt/keyrings

# Adiciona a chave oficial do Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza o apt para reconhecer o novo repositório
sudo apt update -y

# Instala Docker, Docker Compose e ferramentas adicionais
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin git vim nano

# Habilita e inicia o Docker
sudo systemctl enable docker
sudo systemctl start docker

# Adiciona o usuário ubuntu ao grupo Docker para evitar problemas de permissão
sudo usermod -aG docker ubuntu

# Executa como root
sudo -i <<EOF

# Define o diretório onde o repositório será clonado
PROJECT_DIR="/home/ubuntu/observability-stack"

# Clona o repositório na EC2
cd /home/ubuntu/
git clone https://github.com/SalllesAndr/observability-stack.git

# Define permissões corretas para evitar problemas de acesso
chown -R ubuntu:ubuntu $PROJECT_DIR

EOF

sudo systemctl restart docker
