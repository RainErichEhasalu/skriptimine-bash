#!/bin/bash 
# Alustame Bashi skriptiga

# Genereerime suvalise numbri vahemikus 1 kuni 20
# $RANDOM % 20 annab jäägi 0-19, seega +1 teeb sellest 1-20
NUMBER=$(( $RANDOM % 20 + 1 ))

# Loome muutuja katsete lugemiseks ja määrame selle algväärtuseks 0
KATSEID=0

# Loome muutuja kasutaja pakkumise jaoks (alguses tühi)
PAKKUMINE=0

# Palume kasutajal esimest korda arvata
echo "Arva ära 1 number ühest 20-ni:"

# Alustame while tsüklit, mis kestab seni, kuni PAKKUMINE ei võrdu NUMBER-iga
while [ "$PAKKUMINE" -ne "$NUMBER" ]
do
    read PAKKUMINE 
# Loeme kasutaja sisestatud numbri
    ((KATSEID++)) 
# Suurendame katsete lugejat ühe võrra

    # Kontrollime if lausega, kas pakkumine oli õige, liiga väike või liiga suur
    if [ "$PAKKUMINE" -eq "$NUMBER" ]; then
        # Kui arvati õigesti, siis väljastame võiduteate ja katsete arvu
        echo "Õige! number on tõesti $NUMBER"
        echo "Arvasid ära $KATSEID katsega!"
    
    elif [ "$PAKKUMINE" -lt "$NUMBER" ]; then
        # Kui pakkumine oli väiksem (-lt ehk less than) kui suvaline number
        echo "Pakutud number on suurem kui $PAKKUMINE. Paku uuesti:"
    
    else
        # Kui pakkumine oli suurem (-gt ehk greater than) kui suvaline number
        echo "Pakutud number on väiksem kui $PAKKUMINE. Paku uuesti:"
    fi
done 
# Tsükli lõpp
