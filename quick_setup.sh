#!/bin/bash

# VibeVoice ComfyUI Gyors Setup Script
# Használat: ./quick_setup.sh

set -e

echo "=========================================="
echo "VibeVoice ComfyUI Lokális Setup"
echo "=========================================="

# Ellenőrzés hogy Docker fut-e
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker nem fut! Indítsd el a Docker-t és próbáld újra."
    exit 1
fi

echo "✅ Docker fut"
echo ""

# Ellenőrzés hogy Docker Compose elérhető-e
if ! command -v docker-compose &> /dev/null; then
    if ! docker compose version &> /dev/null; then
        echo "❌ Docker Compose nem található!"
        exit 1
    fi
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

echo "✅ Docker Compose elérhető"
echo ""

# Build
echo "🔨 Docker image build..."
docker build -t vibevoice-comfyui:local .

if [ $? -eq 0 ]; then
    echo "✅ Build sikeres!"
    echo ""
else
    echo "❌ Build sikertelen!"
    exit 1
fi

# Mappastruktúra létrehozása
echo "📁 Mappastruktúra létrehozása..."
mkdir -p models input output custom_nodes

# Indítás kérdés
read -p "Indítsuk el most a container-t? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Container indítása..."
    
    # Compose up
    $COMPOSE_CMD up -d
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "✅ ComfyUI sikeresen elindult!"
        echo "=========================================="
        echo ""
        echo "📍 Nyisd meg böngészőben:"
        echo "   http://localhost:8188"
        echo ""
        echo "📊 Logok megtekintése:"
        echo "   $COMPOSE_CMD logs -f"
        echo ""
        echo "🛑 Leállítás:"
        echo "   $COMPOSE_CMD down"
        echo ""
        echo "⚠️  Első indításkor a modellek letöltése"
        echo "   5-10 percet is igénybe vehet!"
        echo "=========================================="
    else
        echo "❌ Indítás sikertelen!"
        exit 1
    fi
fi

echo ""
echo "🎉 Setup kész!"
