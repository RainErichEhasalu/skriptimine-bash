#!/bin/bash

# Määrame kolme serveri IP-aadressid muutujatena
# (Asenda need vastavalt oma klassikaaslaste ja enda masinate IP-dega)
SERVER1="10.100.0.47"
SERVER2="10.100.0.141"
SERVER3="10.100.0.145"

# SSH kasutajanimi (asenda see oma tegeliku kasutajanimega)
USER="student"

# Määrame logifaili nime, kuhu lähevad veateated
LOG_FILE="serverid.txt"

# Käivitame for-tsükli, mis käib läbi kõik kolm IP-aadressi
for IP in $SERVER1 $SERVER2 $SERVER3
do
    # Pingime serverit ühe korra (-c 1) ja ootame maksimaalselt 2 sekundit (-W 2)
    # Suuname nii tavalise väljundi kui ka vead prügikasti (> /dev/null 2>&1)
    ping -c 1 -W 2 $IP > /dev/null 2>&1

    # Kontrollime if-lausega, kas eelneva käsu (ping) lõpetamise kood oli 0 (õnnestus)
    if [ $? -eq 0 ]; then
        # Kui pingimine õnnestus, kuvame vastava teate
        echo "Server aadressiga $IP on võrgus kättesaadav"
        
        # Küsime SSH kaudu serveri algusaega (uptime -s)
        # See eeldab, et ssh-copy-id on eelnevalt tehtud
        START_TIME=$(ssh $USER@$IP "uptime -s" 2>/dev/null)
        
        # Kuvame serveri töösoleku algusaja
        echo "Server on töös olnud alates: $START_TIME"
        # Lisame tühja rea väljundi loetavuse parandamiseks
        echo ""
    else
        # Kui pingimine ebaõnnestus, kuvame veateate ekraanil
        echo "Server aadressiga $IP pole võrgus kättesaadav"
        
        # Lisame kuupäeva, kellaaja ja IP-aadressi logifaili
        # $(date) lisab praeguse ajahetke
        echo "$(date) - Server $IP polnud kättesaadav" >> $LOG_FILE
        
        # Lisame tühja rea ka siia
        echo ""
    fi
done
