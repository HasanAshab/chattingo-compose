#!/bin/bash

# Usage: ./setup.sh <db_password>
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <db_password>"
  exit 1
fi

DB_PASSWORD="$1"
ENV_DIR="$(dirname "$0")/envs"
TARGET_DIR="$(dirname "$0")"

# Get the public IP of the host
PUBLIC_IP=$(curl -4 icanhazip.com)
if [ -z "$PUBLIC_IP" ]; then
    echo "Could not get public IP. Exiting."
    exit 1
fi

# Copy and rename all .example files
for file in "$ENV_DIR"/.env.*.example; do
  [ -e "$file" ] || continue
  base=$(basename "$file")
  target_name="${base/.example/}"
  cp "$file" "$ENV_DIR/$target_name"
done

# Replace variables in all env files (excluding .example files)
for envfile in "$ENV_DIR"/.env.*; do
  if [[ "$envfile" != *.example ]]; then
    [ -e "$envfile" ] || continue
    sed -i "s/^SPRING_DATASOURCE_PASSWORD=.*/SPRING_DATASOURCE_PASSWORD=$DB_PASSWORD/" "$envfile"
    sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$DB_PASSWORD/" "$envfile"
    sed -i "s/^MYSQL_ROOT_PASSWORD$/MYSQL_ROOT_PASSWORD=$DB_PASSWORD/" "$envfile"
    sed -i "s|^REACT_APP_API_URL=.*|REACT_APP_API_URL=http://$PUBLIC_IP:8080|" "$envfile"
    sed -i "s|^CORS_ALLOWED_ORIGINS=.*|CORS_ALLOWED_ORIGINS=http://$PUBLIC_IP:3000|" "$envfile"
  fi
done

echo "Environment files prepared in $ENV_DIR."