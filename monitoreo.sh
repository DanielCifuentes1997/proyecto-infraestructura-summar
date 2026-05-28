#!/bin/bash

# === CONFIGURACIÓN DE COLORES ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin Color

# === VARIABLES ===
LOG_FILE="/home/admin-ti/archivos_compartidos/estado.log"

# === INICIO DEL SCRIPT ===
echo -e "${CYAN}===================================================${NC}"
echo -e "${CYAN}   📊 PANEL DE MONITOREO - SUMMAR PROCESOS S.A.S   ${NC}"
echo -e "${CYAN}===================================================${NC}"
echo -e "🕒 Fecha y Hora actual: $(date +"%Y-%m-%d %H:%M:%S")"
echo ""

# === 1. EXTRACCIÓN DE METRICAS RÁPIDAS PARA CONSOLA ===

# Tiempo en línea del servidor
UPTIME=$(uptime -p)
echo -e "📈 ${YELLOW}Tiempo en línea:${NC} $UPTIME"

# Consumo de RAM (Calcula el porcentaje exacto de uso)
RAM_USADA=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
echo -e "🧠 ${YELLOW}Consumo de Memoria RAM:${NC} $RAM_USADA"

# Uso del Disco duro principal (Muestra el porcentaje usado)
DISCO_USADO=$(df -h / | awk '$NF=="/"{printf "%s", $5}')
echo -e "💾 ${YELLOW}Uso de Almacenamiento Raíz (/):${NC} $DISCO_USADO"

# Verificación rápida de la infraestructura web y BD (Docker)
DOCKER_RUNNING=$(sudo docker ps -q | wc -l)
if [ "$DOCKER_RUNNING" -ge 2 ]; then
    echo -e "🐳 ${YELLOW}Servicios Docker:${NC} ${GREEN}ACTIVOS ($DOCKER_RUNNING contenedores en ejecución)${NC}"
else
    echo -e "🐳 ${YELLOW}Servicios Docker:${NC} ${RED}¡ALERTA! (Solo $DOCKER_RUNNING contenedores corriendo)${NC}"
fi
echo ""

# === 2. GENERACIÓN DEL REPORTE DETALLADO (LOG) ===

echo "===================================================" > "$LOG_FILE"
echo "      REPORTE DE ESTADO - SUMMAR PROCESOS S.A.S    " >> "$LOG_FILE"
echo "===================================================" >> "$LOG_FILE"
echo "Generado: $(date +"%Y-%m-%d %H:%M:%S")" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- 🧠 DETALLE DE MEMORIA RAM ---" >> "$LOG_FILE"
free -h >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- 💾 DETALLE DE ALMACENAMIENTO ---" >> "$LOG_FILE"
df -h >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- 🐳 ESTADO DE LOS CONTENEDORES ---" >> "$LOG_FILE"
sudo docker ps >> "$LOG_FILE"

# === CIERRE ===
echo -e "${CYAN}===================================================${NC}"
echo -e "${GREEN}✅ Diagnóstico finalizado.${NC}"
echo -e "📄 Un reporte detallado fue exportado a: ${GREEN}$LOG_FILE${NC}"
