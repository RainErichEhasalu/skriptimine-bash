#!/bin/bash

# See skript võimaldab kasutajal valida kausta kopeerimise või liigutamise vahel.

# Kuvab valikud kasutajale
echo "Kas soovid kausta kopeerida või liigutada, tee oma valik:"
echo ""
echo "a - kausta kopeerimine"
echo "b - kausta liigutamine"
echo ""
read valik

case $valik in
  a)
    # Kopeerimise protsess
    echo "Millist kausta soovid kopeerida?"
    read source
    echo "Kuhu kausta sa soovid seda kopeerida?"
    read destination
    
    # Kopeerib kausta koos sisu ja alamkaustadega
    cp -r "$source" "$destination"
    echo "Kausta $source kopeerimine kausta $destination on lõppenud"
    ;;

  b)
    # Liigutamise protsess
    echo "Millist kausta soovid liigutada?"
    read source
    echo "Kuhu kausta sa soovid seda liigutada?"
    read destination
    
    # Liigutab kausta sihtkohta
    mv "$source" "$destination"
    echo "Kausta $source liigutamine kausta $destination on lõppenud"
    ;;

  *)
    # Tundmatu valiku korral kuvatakse veateade
    echo "Tundmatu valik! Skript lõpetab oma töö."
    ;;
esac
