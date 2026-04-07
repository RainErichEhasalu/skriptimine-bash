#!/bin/bash 
# Määrame, et kasutame Bashi kesta

# Küsime kasutajalt, millist kausta ta varundada soovib
echo "Millist kausta soovid varundada?"
read ALLIKAS # Loeme sisestuse muutujasse ALLIKAS

# KONTROLL: Kas varundatav kaust on üldse olemas?
if [ ! -d "$ALLIKAS" ]; then # Kui kataloogi (-d) EI OLE (!) olemas
    echo "Kausta ei leitud, skript lõpetab oma töö"
    exit 1 # Lõpetame skripti töö veakoodiga
fi

# Küsime, kuhu kausta varukoopia teha
echo "Kuhu soovid seda varundada?"
read SIHTKOHT # Loeme sisestuse muutujasse SIHTKOHT

# KONTROLL: Kas sihtkoht on olemas?
if [ ! -d "$SIHTKOHT" ]; then # Kui sihtkataloogi EI OLE olemas
    echo "Kausta ei leitud, skript lõpetab oma töö"
    exit 1 # Lõpetame skripti töö
fi

# Teeme valmis ajatempli ja failinime (nt logbu_07.04.26_19.30.05.tar.gz)
AEG=$(date +%d.%m.%y_%H.%M.%S)
FAILINIMI="logbu_$AEG.tar.gz"

# Teostame varunduse tar käsuga
# c = create (loo), z = gzip (paki), f = file (failiks)
tar -czf "$SIHTKOHT/$FAILINIMI" "$ALLIKAS" &> /dev/null

# KONTROLL: Kas varundusfail tekkis edukalt sihtkausta?
if [ -f "$SIHTKOHT/$FAILINIMI" ]; then # Kui fail (-f) on sihtkohas olemas
    # Teavitame kasutajat edukast lõpetamisest vastavalt näidisele
    echo "$ALLIKAS kausta varundamine $SIHTKOHT kausta on edukalt lõppenud, varundusfaili nimi on: $FAILINIMI"
else # Kui faili mingil põhjusel ei tekkinud
    echo "Varundamine ebaõnnestus ja skript lõpetab oma töö"
    exit 1
fi
