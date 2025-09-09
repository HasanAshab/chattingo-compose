#!/bin/bash
# Usage: ./update_tag.sh <service> <tag>
# Example: ./update_tag.sh frontend abc1234

SERVICE="$1"
TAG="$2"

if [[ -z "$SERVICE" || -z "$TAG" ]]; then
  echo "Usage: $0 <service> <tag>"
  exit 1
fi

sed -i "s|image: hasan18205/chattingo-$SERVICE:.*|image: hasan18205/chattingo-$SERVICE:$TAG|" docker-compose.yml

echo "✅ Updated docker-compose.yml for $SERVICE:$TAG"
