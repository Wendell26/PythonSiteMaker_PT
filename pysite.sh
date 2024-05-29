#!/bin/bash

# Definindo cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sem cor

echo -e "${CYAN}Olá, esse script criará um 'site' usando apenas o Termux e Python.${NC}"
read -p "Nome da pasta: " site_path

# Verificar se o diretório já existe
if [ -d "$site_path" ]; then
  echo -e "${RED}O diretório '$site_path' já existe. Usando o diretório existente.${NC}"
else
  mkdir $site_path
fi

cd $site_path
echo -e "${YELLOW}Prepare o arquivo HTML para o site. Abrindo o editor de texto...${NC}"
sleep 0.6
nano index.html
echo -e "${YELLOW}Agora, faça o código JavaScript.${NC}"
sleep 0.6
nano script.js
echo -e "${YELLOW}Vamos adicionar estilo ao site.${NC}"
sleep 0.6
nano style.css
echo -e "${CYAN}Pronto. Vamos configurar o servidor.${NC}"
read -p "Porta: " port
read -p "O servidor será inicializado se essa porta não estiver sendo usada. Tem certeza de inicializar o servidor na porta $port? (S/n) " port_choice

if [ "$port_choice" == "S" ]; then
  echo -e "${GREEN}Inicializando servidor...${NC}"
  # Iniciar o servidor em segundo plano e capturar o PID
  python -m http.server $port --bind $(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 ) &
  server_pid=$!
  sleep 1
  
  # Verificar se o servidor está em execução
  if ps -p $server_pid > /dev/null; then
    echo -e "${GREEN}Servidor inicializado em $(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1)
:$port!${NC}"
  else
    echo -e "${RED}Erro ao inicializar o servidor. Fechando o Termux...${NC}"
   pkill python
   pkill com.termux
  fi
else
  echo -e "${RED}Inicialização do servidor cancelada.${NC}"
fi
