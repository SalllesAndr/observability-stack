#!/bin/bash
set -e  # Para parar a execução em caso de erro

# Atualizar pacotes e instalar dependências
sudo apt update -y
sudo apt install -y docker.io docker-compose unzip nginx git

# Iniciar e habilitar Docker e Nginx
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start nginx
sudo systemctl enable nginx

# Clonar o repositório do GitHub
cd /home/ubuntu
git clone https://github.com/seu-usuario/observability-stack.git
cd observability-stack

# Copiar configurações do Nginx para os diretórios corretos
sudo cp stack-observability/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp stack-observability/nginx/conf.d/sites-available/* /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/grafana.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/prometheus.conf /etc/nginx/sites-enabled/

# Testar e reiniciar o Nginx para aplicar as mudanças
sudo nginx -t && sudo systemctl restart nginx

# Subir os serviços via Docker Compose
cd /home/ubuntu/observability-stack/stack-observability
docker-compose up -d
