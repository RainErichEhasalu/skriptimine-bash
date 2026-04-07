#!/bin/bash

# Määrame vajalikud muutujad
SOURCE_DIR="/var/vanadfailid"
BACKUP_DIR="/var/backups"
# Genereerime kuupäeva vormingus DDMMYY
DATE=$(date +%d%m%y)
BACKUP_FILE="$BACKUP_DIR/varundus_$DATE.tar.gz"

# Kontrollime kohe alguses, kas juurkaust on üldse olemas
if [ ! -d "$SOURCE_DIR" ]; then
    # Kui kausta pole, siis teatame ja lõpetame skripti töö
    echo "Kausta ei leitud, skript seiskub"
    exit 1
fi

# Kui kaust on olemas, küsime kasutajalt valikut
echo "Mida soovid kaustaga teha:"
echo "a = Soovin kausta varundada"
echo "b = Soovin kausta sisu kustutada"

# Loeme kasutaja sisendi
read -p "" valik

# Kasutame case struktuuri valikute töötlemiseks
case $valik in
    a)
        # Varundamise valik
        # Loome varukoopiate kataloogi
        mkdir -p "$BACKUP_DIR"
        
        # Teostame pakkimise
        tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .
        
        # Teavitame kasutajat asukohast
        echo "Varundus asukohta $BACKUP_FILE teostatud"
        ;;
    b)
        # Kustutamise valik
        # Eemaldame kõik failid kaustast
        rm -rf "${SOURCE_DIR:?}"/*
        
        # Teavitame kasutajat tühjendamisest
        echo "Kausta $SOURCE_DIR sisu kustutatud"
        ;;
    *)
        # Kui kasutaja sisestas midagi muud
        echo "Vale valik, skript lõpetab töö"
        ;;
esac
