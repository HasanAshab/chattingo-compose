#!/bin/bash

# Usage: ./setup.sh <db_password>
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <db_password>"
  exit 1
fi

DB_PASSWORD="$1"
ENV_DIR="$(dirname "$0")/envs"
TARGET_DIR="$(dirname "$0")"

# Copy and rename all .sample/.example files
for file in "$ENV_DIR"/.env.*.sample "$ENV_DIR"/.env.*.example; do
  [ -e "$file" ] || continue
  base=$(basename "$file")
  target_name="${base/.sample/}"
  target_name="${target_name/.example/}"
  cp "$file" "$ENV_DIR/$target_name"

done

# Replace password variables in all env files
for envfile in "$ENV_DIR"/.env.*; do
  [ -e "$envfile" ] || continue
  sed -i "s/^SPRING_DATASOURCE_PASSWORD=.*/SPRING_DATASOURCE_PASSWORD=$DB_PASSWORD/" "$envfile"
  sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$DB_PASSWORD/" "$envfile"
  sed -i "s/^MYSQL_ROOT_PASSWORD$/MYSQL_ROOT_PASSWORD=$DB_PASSWORD/" "$envfile"
done

echo "Environment files prepared in $ENV_DIR."
