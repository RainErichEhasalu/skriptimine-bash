#!/bin/bash

# See skript varundab logifaile automaatselt ilma ekraaniväljundita.

# Määratud muutujad varundatava kausta ja sihtkoha jaoks
source_path="/var/log"
destination_path="/varundus"

# Kuupäeva ja kellaaja genereerimine failinime jaoks (pp.kk.aa_tt.mm.ss)
timestamp=$(date +"%d.%m.%y_%H.%M.%S")
filename="logsbu_${timestamp}.tar.gz"

# Teostab varundamise ja peidab kogu väljundi (nii info kui vead)
tar -czf "${destination_path}/${filename}" "$source_path" &> /dev/null
