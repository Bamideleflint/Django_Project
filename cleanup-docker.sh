#!/bin/bash

# Docker Cleanup Script
# This script stops containers and removes images to free up space

echo "🐳 Docker Cleanup"
echo "================="
echo ""

# Stop all running containers for this project
echo "🛑 Stopping running containers..."
docker-compose down

if [ $? -eq 0 ]; then
    echo "✅ Containers stopped"
else
    echo "⚠️  No containers were running or docker-compose.yml not found"
fi

echo ""
echo "🗑️  Removing Docker images..."

# List images related to this project
echo "Current Django-related images:"
docker images | grep -E "django|Django_Project" || echo "No Django images found"

echo ""
read -p "Do you want to remove ALL unused Docker images? (yes/no): " confirm

if [ "$confirm" == "yes" ]; then
    echo ""
    echo "🧹 Removing unused images..."
    docker image prune -a -f
    
    echo ""
    echo "🧹 Removing unused volumes..."
    docker volume prune -f
    
    echo ""
    echo "🧹 Removing unused networks..."
    docker network prune -f
    
    echo ""
    echo "✅ Docker cleanup complete!"
else
    echo "❌ Image removal cancelled."
fi

echo ""
echo "📊 Docker disk usage:"
docker system df

echo ""
echo "💡 To free up even more space, run: docker system prune -a --volumes"
