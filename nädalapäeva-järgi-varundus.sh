#!/bin/bash 
# Ütleme süsteemile, et see on Bashi skript

# Määrame muutuja, millist kausta me varundada tahame
ALLIKAS="/var/log" 

# Teeme muutuja nimega AEG, mis vormistab kuupäeva täpselt nii nagu näidises: päev.kuu.aasta_kell.minut.sekund
AEG=$(date +%d.%m.%y_%H.%M.%S) 

# Võtame nädalapäeva numbrina (1 on esmaspäev, 7 on pühapäev), et saaksime seda kontrollida
NADALAPAEV=$(date +%u) 

# Kasutame case valikut, et otsustada, kuhu kausta täna failid lähevad
case $NADALAPAEV in 
    1|3|5) # Kui täna on esmaspäev, kolmapäev või reede
        SIHTKAUST="/varundus/esimene" # Valime esimese kausta
        ;; # See osa on tehtud
    2|4|6) # Kui täna on teisipäev, neljapäev või laupäev
        SIHTKAUST="/varundus/teine" # Valime teise kausta
        ;; # See osa on tehtud
    7) # Kui täna on pühapäev
        SIHTKAUST="/varundus/kolmas" # Valime kolmanda kausta
        ;; # See osa on tehtud
esac # Case valik saab siinkohal läbi

# Loome vajadusel sihtkausta ära, kui seda veel olemas pole
mkdir -p $SIHTKAUST 

# Paneme kokku failinime, kasutades algust "logsbu_", meie aja muutujat ja lõppu ".tar.gz"
FAILINIMI="logsbu_$AEG.tar.gz" 

# Teeme varukoopia tar käsuga. -czf tähendab, et loome pakitud faili.
# "&> /dev/null" rea lõpus hoolitseb selle eest, et ekraanile ei tuleks ühtegi teadet.
tar -czf "$SIHTKAUST/$FAILINIMI" "$ALLIKAS" &> /dev/null
