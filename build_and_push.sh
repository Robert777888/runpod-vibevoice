#!/bin/bash

# VibeVoice ComfyUI Docker Build és Push Script
# Használat: ./build_and_push.sh [dockerhub_username]

set -e

DOCKERHUB_USERNAME=${1:-"yourusername"}
IMAGE_NAME="vibevoice-comfyui"
TAG="latest"
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "=========================================="
echo "VibeVoice ComfyUI Docker Build"
echo "=========================================="
echo "Image: ${FULL_IMAGE_NAME}"
echo ""

# Build the image
echo "🔨 Building Docker image..."
docker build -t ${FULL_IMAGE_NAME} .

if [ $? -eq 0 ]; then
    echo "✅ Build sikeres!"
    echo ""
    
    # Kérdés a push-ról
    read -p "Push-old Docker Hub-ra? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Pushing to Docker Hub..."
        
        # Login check
        if ! docker info | grep -q "Username"; then
            echo "📝 Jelentkezz be Docker Hub-ra:"
            docker login
        fi
        
        # Push
        docker push ${FULL_IMAGE_NAME}
        
        if [ $? -eq 0 ]; then
            echo "✅ Push sikeres!"
            echo ""
            echo "=========================================="
            echo "RunPod Template Konfiguráció:"
            echo "=========================================="
            echo "Container Image: ${FULL_IMAGE_NAME}"
            echo "Container Disk: 50GB"
            echo "Expose HTTP Ports: 8188"
            echo "=========================================="
        else
            echo "❌ Push sikertelen!"
            exit 1
        fi
    fi
else
    echo "❌ Build sikertelen!"
    exit 1
fi

echo ""
echo "🎉 Kész! Most már használhatod a RunPod-on!"
