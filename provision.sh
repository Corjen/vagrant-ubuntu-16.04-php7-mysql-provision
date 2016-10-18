#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

#sudo aptitude update -q

# Force a blank root password for mysql

sudo mysql -u root -e "CREATE USER IF NOT EXISTS 'dev'@'localhost' IDENTIFIED BY 'dev'";
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO 'dev'@'localhost';";
sudo mysql -u root -e "FLUSH PRIVILEGES";

sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat >> /etc/nginx/sites-available/default <<'EOF'
server {
  listen 80;

  root /var/www/example.dev/html;
  index index.php;

  server_name example.dev;
  sendfile off;

  location / {
      try_files $uri $uri/ /index.php?q=$uri&$args;
  }

  location /wordpress {
      index index.php;
      try_files $uri $uri/ /index.php?q=$uri&$args;
  }

  # pass the PHP scripts to FastCGI server listening on /tmp/php7.0-fpm.sock
  #
  location ~ \.php$ {
       	fastcgi_pass unix:/run/php/php7.0-fpm.sock;
       	fastcgi_split_path_info ^(.+\.php)(/.+)$;
       	try_files $fastcgi_script_name =404;
       	set $path_info $fastcgi_path_info;
       	fastcgi_param PATH_INFO $path_info;
       	fastcgi_index index.php;
       	include fastcgi.conf;
  }
}
EOF

mysql -u root -e 'CREATE DATABASE IF NOT EXISTS example_develop;'

sudo service nginx restart

sudo service mysql restart

sudo service php7.0-fpm restart
