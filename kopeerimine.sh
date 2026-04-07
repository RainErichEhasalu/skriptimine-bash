#!/bin/bash

# See skript kopeerib ühe kausta sisu teise kohta interaktiivselt.
# Autor: Gemini (kasutaja ülesande põhjal)
# Kuupäev: 07.04.2026

# 1. Küsib, millist kausta soovitakse kopeerida
echo "Millist kausta soovid kopeerida?"
# 2. Loeb sisestuse muutujasse 'source'
read source

# 3. Küsib, kuhu kausta soovitakse kopeerida
echo ""
echo "Kuhu soovid selle kopeerida?"
# 4. Loeb sisestuse muutujasse 'destination'
read destination

# 5. Teostab kopeerimise kasutades muutujaid. 
# Võti -r (recursive) tagab, et kopeeritakse kaust koos kõigi failide ja alamkaustadega.
cp -r "$source" "$destination"

# 6. Väljastab tulemuse teavituse
echo ""
echo "Kausta $source kopeerimine kausta $destination on lõppenud"
