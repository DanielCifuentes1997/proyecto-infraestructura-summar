#!/bin/bash

# === CONFIGURACIÓN DE COLORES ===
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin Color

PROYECTO_DIR="/home/admin-ti/proyecto-ti"

# === INICIO DEL SCRIPT ===
echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}  🚀 ORQUESTADOR DE SERVICIOS - SUMMAR PROCESOS S.A.S  ${NC}"
echo -e "${BLUE}===================================================${NC}"
echo -e "🕒 Iniciando despliegue: $(date +"%Y-%m-%d %H:%M:%S")\n"

# === VALIDACIÓN 1: Comprobación de directorio y archivo yaml ===
if [ ! -d "$PROYECTO_DIR" ]; then
    echo -e "${RED}❌ ERROR: El directorio del proyecto ($PROYECTO_DIR) no existe.${NC}"
    exit 1
fi

cd "$PROYECTO_DIR" || exit

if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ ERROR: No se encontró el archivo docker-compose.yml en $PROYECTO_DIR.${NC}"
    exit 1
fi

echo -e "🐳 ${YELLOW}Levantando contenedores en segundo plano (Nginx & MariaDB)...${NC}"

# === EJECUCIÓN: Despliegue de Docker Compose ===
if sudo docker-compose up -d; then
    echo -e "\n${GREEN}✅ Despliegue finalizado exitosamente.${NC}\n"
else
    echo -e "\n${RED}❌ ERROR CRÍTICO: Falló el comando docker-compose.${NC}\n"
    exit 1
fi

# === AUDITORÍA VISUAL ===
echo -e "${BLUE}--- ESTADO ACTUAL DE LOS CONTENEDORES ---${NC}"
sudo docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

echo -e "\n${BLUE}===================================================${NC}"
