#!/bin/bash

# Install required packages
sudo apt update && sudo apt upgrade -y

sudo apt install nginx mysql-server php-fpm php-mysql -y

# Configure PHP for Nginx
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/8.1/fpm/php.ini
sudo systemctl restart php8.1-fpm

# Configure Nginx for WordPress
sudo  mkdir -p /var/www/html/wordpress/public_html
sudo cat > /etc/nginx/sites-available/wordpress.conf <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name myhs.mooo.com localhost;

    access_log /var/log/nginx/wp.access.log;
    error_log /var/log/nginx/wp.error.log;
    root  /var/www/html/wordpress/public_html;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    
    location ~ /\.ht {
                deny all;
    }

    location = /favicon.ico {
                log_not_found off;
                access_log off;
    }

    location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off; 
    }
}
EOF

# Enable WordPress config
sudo ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Setup WordPress
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';"
# Step 6: Download and Configure WordPress
cd /var/www/html/wordpress/public_html
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
mv wordpress/* .
rm -rf wordpress
# Set the Write Permission 
cd /var/www/html/wordpress/public_html
chown -R www-data:www-data *
chmod -R 755 *
#Set DB Creds 
mv wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/wordpress/g" wp-config.php
sudo sed -i "s/username_here/wordpress/g" wp-config.php  
sudo sed -i "s/password_here/password/g" wp-config.php
