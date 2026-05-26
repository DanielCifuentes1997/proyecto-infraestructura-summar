#!/bin/bash

 # Variables de directorios
FECHA=$(date +"%Y%m%d_%H%M")
ORIGEN="/home/admin-ti/proyecto-ti"
DESTINO="/home/admin-ti/archivos_compartidos/backup_summar_$FECHA.tar.gz"
LOG="/home/admin-ti/archivos_compartidos/registro_backups.log"

echo "Iniciando respaldo de la insfraestrcutura..."

# Comando para compirmir la carpeta en un .tar.gz
tar -czf $DESTINO $ORIGEN 2>/dev/null

# Confirmacion y registro
echo "Respaldo exitoso. Archivo guardado en: $DESTINO"
echo "Backup realizado el $(date)" >> $LOG
