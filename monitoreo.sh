#!/bin/bash
cd /home/admin-ti/archivos_compartidos
date > estado.log
free -h >> estado.log
df -h >> estado.log
