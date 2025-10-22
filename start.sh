#!/bin/bash

echo "=========================================="
echo "VibeVoice ComfyUI RunPod Indítása"
echo "=========================================="

cd /workspace/ComfyUI

# Modellek letöltése ha még nincsenek meg
if [ ! -d "/workspace/ComfyUI/models/VibeVoice/diffusion_head/hungarian" ]; then
    echo "Magyar diffusion head modell letöltése..."
    huggingface-cli download Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17 \
        --local-dir /workspace/ComfyUI/models/VibeVoice/diffusion_head/hungarian \
        --local-dir-use-symlinks False
fi

if [ ! -d "/workspace/ComfyUI/models/VibeVoice/base_model" ] || [ -z "$(ls -A /workspace/ComfyUI/models/VibeVoice/base_model)" ]; then
    echo "Alap VibeVoice modell letöltése..."
    huggingface-cli download vibeai/vibevoice-7b-base-v1 \
        --local-dir /workspace/ComfyUI/models/VibeVoice/base_model \
        --local-dir-use-symlinks False
fi

echo "Modellek betöltve!"
echo ""
echo "=========================================="
echo "ComfyUI indítása..."
echo "=========================================="
echo "Elérhető lesz: http://localhost:8188"
echo "RunPod URL: Nézd meg a RunPod connect gombját!"
echo "=========================================="

# ComfyUI indítása
python main.py --listen 0.0.0.0 --port 8188
