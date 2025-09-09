set -e

echo ">>> Pulling latest compose repo..."
git reset --hard
git pull origin main

echo ">>> Rebuilding and restarting containers..."
docker-compose down
docker-compose pull
docker-compose up -d --build

echo ">>> Cleaning unused images..."
docker image prune -af