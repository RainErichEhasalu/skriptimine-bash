#!/bin/bash

# See skript loob interaktiivselt kaustast tar.gz varukoopia.

echo "Millist kausta soovid varundada?"
read source_dir

echo ""
echo "Kuhu soovid selle varundada?"
read backup_dir

# Moodustab kuupäeva ja kellaaja vormingus ddmmyy_hhmmss
timestamp=$(date +"%d%m%y_%H%M%S")

# Määrab failinime
filename="logbu_${timestamp}.tar.gz"

# Teostab varundamise ja peidab väljundi
tar -czf "${backup_dir}/${filename}" "$source_dir" &> /dev/null

echo ""
echo "Kausta $source_dir varundamine kausta $backup_dir on lõppenud"
echo "Varundusfaili nimi on $filename"
