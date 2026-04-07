#!/bin/bash

# Kontrollime, et skripti käivitatakse juurkasutaja õigustes
if [ "$EUID" -ne 0 ]; then
  echo "Palun käivita skript sudo-ga!"
  exit
fi

# 1. KASUTAJA SISENDID
# Küsime andmebaasi andmed interaktiivselt
echo "Andmebaasi nimi:"
read db_name

echo "Andmebaasi kasutajanimi:"
read db_user

# Kasutame -s lippu, et parooli sisestamisel tärne ei kuvataks
echo "Andmebaasi parool:"
read -s db_password
echo ""

echo "WordPressi kausta nimi, mis luuakse /var/www kausta:"
read wp_folder

# Kinnitus enne jätkamist
echo "Kas käivitan paigalduse? (y/n)"
read confirm
if [ "$confirm" != "y" ]; then
    echo "Paigaldus katkestatud."
    exit
fi

# ---------------------------------------------------------
# 1. ANDMEBAASI PAIGALDAMINE JA SEADISTAMINE
# ---------------------------------------------------------
echo "=========================================="
echo "1. Andmebaasi paigaldamine ja seadistamine"
echo "=========================================="
echo "Alustan andmebaasi paigaldamist..."

# Paigaldame MariaDB serveri taustal
apt-get update > /dev/null
apt-get install -y mariadb-server > /dev/null

# Loome andmebaasi ja kasutaja ning anname õigused
mysql -e "CREATE DATABASE $db_name;"
mysql -e "CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_password';"
mysql -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "Andmebaas $db_name ja kasutaja $db_user on loodud."

# ---------------------------------------------------------
# 2. APACHE VEEBISERVERI PAIGALDAMINE
# ---------------------------------------------------------
echo "------------------------------------------"
echo "2. Apache veebiserveri paigaldamine"
echo "------------------------------------------"
echo "Alustan veebiserveri paigaldamist..."

# Paigaldame Apache2 taustal
apt-get install -y apache2 > /dev/null

echo "Veebiserver edukalt paigaldatud."

# ---------------------------------------------------------
# 3. PHP PAIGALDAMINE
# ---------------------------------------------------------
echo "------------------------------------------"
echo "3. PHP paigaldamine"
echo "------------------------------------------"
echo "Alustan PHP paigaldamist..."

# Paigaldame PHP ja WordPressile vajalikud laiendused
apt-get install -y php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip > /dev/null

echo "PHP ja vajalikud laiendused paigaldatud."

# ---------------------------------------------------------
# 4. WORDPRESSI PAIGALDAMINE
# ---------------------------------------------------------
echo "------------------------------------------"
echo "4. WordPressi paigaldamine"
echo "------------------------------------------"
echo "Alustan WordPressi paigaldamist..."

# Laeme alla uusima WordPressi paketi /tmp kausta
wget -q https://wordpress.org/latest.tar.gz -P /tmp

# Loome sihtkoha kausta
mkdir -p /var/www/$wp_folder

# Pakime failid lahti otse sihtkausta
tar -xzf /tmp/latest.tar.gz -C /var/www/$wp_folder --strip-components=1

# Seadistame failiõigused Apache kasutajale (www-data)
chown -R www-data:www-data /var/www/$wp_folder
chmod -R 755 /var/www/$wp_folder

# Kasutame WordPressi näidiskonfiguuri, et luua wp-config.php
cp /var/www/$wp_folder/wp-config-sample.php /var/www/$wp_folder/wp-config.php

# Asendame konf-failis andmebaasi seaded kasutaja sisestatutega
sed -i "s/database_name_here/$db_name/" /var/www/$wp_folder/wp-config.php
sed -i "s/username_here/$db_user/" /var/www/$wp_folder/wp-config.php
sed -i "s/password_here/$db_password/" /var/www/$wp_folder/wp-config.php

echo "WordPressi paigaldamine on lõppenud."

# ---------------------------------------------------------
# 5. VEEBISERVERI SEADISTAMINE
# ---------------------------------------------------------
echo "------------------------------------------"
echo "5. Veebiserveri seadistamine"
echo "------------------------------------------"
echo "Alustan veebiserveri seadistamist..."

# Loome uue Apache virtuaalhosti faili
cat <<EOF > /etc/apache2/sites-available/$wp_folder.conf
<VirtualHost *:80>
    DocumentRoot /var/www/$wp_folder
    <Directory /var/www/$wp_folder>
        AllowOverride All
    </Directory>
</VirtualHost>
EOF

# Aktiveerime uue saidi ja deaktiveerime vaikesaidi
a2ensite $wp_folder.conf > /dev/null
a2dissite 000-default.conf > /dev/null
# Aktiveerime ümberkirjutamise mooduli (vajalik WP linkidele)
a2enmod rewrite > /dev/null

# Taaskäivitame Apache, et muudatused jõustuksid
systemctl restart apache2

echo "Veebiserveri seadistamine on edukalt lõppenud."
echo "=========================================="
echo "Paigaldusprotsess on nüüd lõppenud. WordPress avaneb lehelt http://localhost"
echo "=========================================="
