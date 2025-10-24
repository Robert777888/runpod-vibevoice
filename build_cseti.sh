#!/bin/bash

# 🇭🇺 CSETI MAGYAR TTS - DOCKER BUILD SCRIPT
# =============================================

set -e  # Kilépés hiba esetén

echo "==========================================="
echo "🇭🇺 CSETI MAGYAR VIBEVOICE TTS - BUILD"
echo "==========================================="
echo ""

# Színek
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Változók
IMAGE_NAME="robert777888/vibevoice-comfyui-cseti"
VERSION="v1.0"
DOCKERFILE="Dockerfile.cseti"

# Ellenőrzések
echo -e "${BLUE}🔍 Ellenőrzések...${NC}"

# Docker fut?
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker nem fut! Indítsd el Docker Desktop-ot!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker fut${NC}"

# Dockerfile létezik?
if [ ! -f "$DOCKERFILE" ]; then
    echo -e "${RED}❌ $DOCKERFILE nem található!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ $DOCKERFILE megvan${NC}"

# Elég szabad hely? (min 30GB)
FREE_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/Gi//')
if [ "$FREE_SPACE" -lt 30 ]; then
    echo -e "${YELLOW}⚠️  Figyelem: Kevés lehet a hely (${FREE_SPACE}GB szabad)${NC}"
    echo -e "${YELLOW}   Minimum 30GB ajánlott!${NC}"
    read -p "Folytatod? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✅ Elég szabad hely (${FREE_SPACE}GB)${NC}"
fi

echo ""
echo "==========================================="
echo "📦 DOCKER BUILD INDÍTÁSA"
echo "==========================================="
echo ""
echo -e "${BLUE}Image:${NC} $IMAGE_NAME:$VERSION"
echo -e "${BLUE}Dockerfile:${NC} $DOCKERFILE"
echo -e "${BLUE}Platform:${NC} linux/amd64"
echo ""
echo -e "${YELLOW}⏱️  Várható idő: 30-40 perc${NC}"
echo ""

# Megerősítés
read -p "Indítsuk a build-et? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Build megszakítva.${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}🚀 BUILD INDÍTÁS...${NC}"
echo ""

# Build kezdete
BUILD_START=$(date +%s)

# Docker build
docker build --platform linux/amd64 \
    -f "$DOCKERFILE" \
    -t "$IMAGE_NAME:$VERSION" \
    -t "$IMAGE_NAME:latest" \
    .

BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))
BUILD_MINUTES=$((BUILD_TIME / 60))
BUILD_SECONDS=$((BUILD_TIME % 60))

echo ""
echo "==========================================="
echo -e "${GREEN}✅ BUILD SIKERES!${NC}"
echo "==========================================="
echo -e "${BLUE}Idő:${NC} ${BUILD_MINUTES}m ${BUILD_SECONDS}s"
echo ""

# Image méret ellenőrzés
IMAGE_SIZE=$(docker images "$IMAGE_NAME:$VERSION" --format "{{.Size}}")
echo -e "${BLUE}Image méret:${NC} $IMAGE_SIZE"
echo ""

# Push kérdés
echo "==========================================="
echo "🚀 DOCKER PUSH"
echo "==========================================="
echo ""
read -p "Push Docker Hub-ra? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${GREEN}📤 PUSH INDÍTÁS...${NC}"
    echo ""
    
    # Docker login ellenőrzés
    if ! docker info | grep -q "Username:"; then
        echo -e "${YELLOW}⚠️  Nincs bejelentkezve Docker Hub-ra!${NC}"
        echo -e "${BLUE}Jelentkezz be:${NC}"
        docker login
    fi
    
    PUSH_START=$(date +%s)
    
    # Push both tags
    echo -e "${BLUE}Pushing $IMAGE_NAME:$VERSION...${NC}"
    docker push "$IMAGE_NAME:$VERSION"
    
    echo -e "${BLUE}Pushing $IMAGE_NAME:latest...${NC}"
    docker push "$IMAGE_NAME:latest"
    
    PUSH_END=$(date +%s)
    PUSH_TIME=$((PUSH_END - PUSH_START))
    PUSH_MINUTES=$((PUSH_TIME / 60))
    PUSH_SECONDS=$((PUSH_TIME % 60))
    
    echo ""
    echo "==========================================="
    echo -e "${GREEN}✅ PUSH SIKERES!${NC}"
    echo "==========================================="
    echo -e "${BLUE}Idő:${NC} ${PUSH_MINUTES}m ${PUSH_SECONDS}s"
    echo ""
    
    # Docker Hub link
    echo -e "${GREEN}🔗 Docker Hub:${NC}"
    echo "   https://hub.docker.com/r/$IMAGE_NAME"
    echo ""
fi

# Összefoglalás
TOTAL_TIME=$(($(date +%s) - BUILD_START))
TOTAL_MINUTES=$((TOTAL_TIME / 60))
TOTAL_SECONDS=$((TOTAL_TIME % 60))

echo "==========================================="
echo "🎉 KÉSZ!"
echo "==========================================="
echo ""
echo -e "${BLUE}Total idő:${NC} ${TOTAL_MINUTES}m ${TOTAL_SECONDS}s"
echo -e "${BLUE}Image:${NC} $IMAGE_NAME:$VERSION"
echo -e "${BLUE}Méret:${NC} $IMAGE_SIZE"
echo ""
echo "==========================================="
echo "🚀 KÖVETKEZŐ LÉPÉSEK"
echo "==========================================="
echo ""
echo "1️⃣  RunPod Template létrehozása:"
echo "    - Container: $IMAGE_NAME:$VERSION"
echo "    - Disk: 50GB"
echo "    - GPU: RTX 4090"
echo ""
echo "2️⃣  Pod indítása"
echo ""
echo "3️⃣  ComfyUI elérése:"
echo "    https://[pod-id]-8188.proxy.runpod.net"
echo ""
echo "4️⃣  Workflow betöltése:"
echo "    Hungarian-LoRA-Cseti.json"
echo ""
echo "5️⃣  Élvezd a tökéletes magyar TTS-t! 🇭🇺🎉"
echo ""
echo "==========================================="
echo ""

# Cleanup kérdés
read -p "Töröljem a build cache-t? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}🧹 Cache tisztítás...${NC}"
    docker builder prune -f
    echo -e "${GREEN}✅ Cache törölve${NC}"
fi

echo ""
echo -e "${GREEN}🎊 MINDEN KÉSZ! SZUPER MUNKA! 💪${NC}"
echo ""
