#!/bin/bash

# === CONFIGURACIÓN DE COLORES ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin Color

# === VARIABLES DE DIRECTORIOS ===
FECHA=$(date +"%Y%m%d_%H%M")
ORIGEN="/home/admin-ti/proyecto-ti"
DESTINO="/home/admin-ti/archivos_compartidos/backup_summar_$FECHA.tar.gz"
LOG="/home/admin-ti/archivos_compartidos/registro_backups.log"

# === INICIO DEL SCRIPT ===
echo -e "${YELLOW}===============================================${NC}"
echo -e "${YELLOW}   SISTEMA DE RESPALDO - SUMMAR PROCESOS S.A.S   ${NC}"
echo -e "${YELLOW}===============================================${NC}"
echo -e "🕒 Iniciando proceso de respaldo: $(date +"%Y-%m-%d %H:%M:%S")"

# === VALIDACIÓN 1: ¿Existe la carpeta origen? ===
if [ ! -d "$ORIGEN" ]; then
    echo -e "${RED}❌ ERROR: El directorio origen ($ORIGEN) no existe o fue movido.${NC}"
    echo "[FALLO] $(date +"%Y-%m-%d %H:%M:%S") - Error: Directorio origen no encontrado." >> "$LOG"
    echo -e "${YELLOW}===============================================${NC}"
    exit 1
fi

echo -e "⏳ Comprimiendo infraestructura web y base de datos..."

# === EJECUCIÓN Y VALIDACIÓN 2: ¿Funcionó la compresión? ===
if tar -czf "$DESTINO" "$ORIGEN" 2>/dev/null; then
    # Si fue exitoso, calculamos el peso del archivo
    TAMANO=$(du -sh "$DESTINO" | awk '{print $1}')
    
    echo -e "${GREEN}✅ Respaldo completado con éxito.${NC}"
    echo -e "📁 Archivo guardado en: ${GREEN}$DESTINO${NC}"
    echo -e "💾 Tamaño del respaldo: ${GREEN}$TAMANO${NC}"
    
    # Confirmación y registro en el LOG
    echo "[EXITO] $(date +"%Y-%m-%d %H:%M:%S") - Backup creado: $DESTINO (Peso: $TAMANO)" >> "$LOG"
else
    # Si la compresión falla por falta de permisos o espacio
    echo -e "${RED}❌ ERROR CRÍTICO: Falló la creación del archivo de respaldo.${NC}"
    echo "[ERROR] $(date +"%Y-%m-%d %H:%M:%S") - Falló el comando tar al comprimir $ORIGEN" >> "$LOG"
    exit 1
fi

echo -e "${YELLOW}===============================================${NC}"
