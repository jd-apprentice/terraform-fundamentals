#!/bin/bash

EC2_PUBLIC_DNS=$1
USER=$2

ssh -tt -i ~/.ssh/dyallab-key $USER@$EC2_PUBLIC_DNS <<EOF

  ## Permissions to execute scripts
  for script in /scripts/*.sh; do
    chmod +x \$script
  done

  ## Docker
  docker pull dyallo/dolar-hoy-api:latest
  docker run -d --name dolar-hoy-api -p ${PORT}:${PORT} -e HOST=${HOST} -e USERNAME=${USERNAME} -e PASSWORD=${PASSWORD} -e DATABASE=${DATABASE} -e MANUAL_USERNAME=${MANUAL_USERNAME} -e MANUAL_PASSWORD=${MANUAL_PASSWORD} dyallo/dolar-hoy-api:latest

  ## Nginx
  sh /scripts/install-nginx.sh
  sudo systemctl start nginx
  cat <<EOFN > /etc/nginx/sites-available/dolar.jonathan.com.ar
  server {
      server_name dolar.jonathan.com.ar;

      location / {
          proxy_pass http://localhost:4500;
          proxy_http_version 1.1;
          proxy_set_header Upgrade \$http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host \$host;
          proxy_cache_bypass \$http_upgrade;
      }
  }
  EOFN
  ln -s /etc/nginx/sites-available/dolar.jonathan.com.ar /etc/nginx/sites-enabled/dolar.jonathan.com.ar
  nginx -s reload

  ## Certbot
  sh /scripts/install-certbot.sh
  certbot --nginx -n -d dolar.jonathan.com.ar --agree-tos --email contacto@jonathan.com.ar --no-eff-email
EOF
