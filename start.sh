#!/bin/bash

echo "=========================================="
echo "🇭🇺 CSETI MAGYAR TTS - INDÍTÁS"
echo "=========================================="
echo ""

# Változók
MODEL_DIR="/workspace/ComfyUI/models/vibevoice"
CSETI_MODEL="$MODEL_DIR/VibeVoice_7B_hun_v2"
TOKENIZER_DIR="$MODEL_DIR/tokenizer"
LORA_DIR="$MODEL_DIR/loras"

# Ellenőrzés: vannak-e már a modellek?
if [ -d "$CSETI_MODEL" ] && [ -d "$TOKENIZER_DIR" ] && [ -d "$LORA_DIR/HUN-900" ]; then
    echo "✅ Modellek már megvannak!"
    echo ""
else
    echo "📥 MODELLEK LETÖLTÉSE (első indulás)..."
    echo "⏱️  Ez 10-15 percet vesz igénybe (~17 GB)"
    echo ""
    
    # 1. CSETI FŐ MODELL (~14GB)
    if [ ! -d "$CSETI_MODEL" ]; then
        echo "🇭🇺 1/3 Cseti Magyar Modell letöltése..."
        cd "$MODEL_DIR"
        huggingface-cli download Cseti/VibeVoice_7B_hun_v2 \
            --local-dir VibeVoice_7B_hun_v2 \
            --local-dir-use-symlinks False
        echo "✅ Cseti modell kész!"
        echo ""
    fi
    
    # 2. TOKENIZER (~11MB)
    if [ ! -d "$TOKENIZER_DIR" ]; then
        echo "📝 2/3 Tokenizer letöltése..."
        mkdir -p "$TOKENIZER_DIR"
        cd "$TOKENIZER_DIR"
        huggingface-cli download Qwen/Qwen2.5-1.5B \
            tokenizer_config.json \
            vocab.json \
            merges.txt \
            tokenizer.json \
            --local-dir . \
            --local-dir-use-symlinks False
        echo "✅ Tokenizer kész!"
        echo ""
    fi
    
    # 3. MAGYAR LORA-K (~2.7GB)
    if [ ! -d "$LORA_DIR/HUN-900" ]; then
        echo "🎨 3/3 Magyar LoRA-k letöltése..."
        mkdir -p "$LORA_DIR"
        cd "$LORA_DIR"
        
        # Teljes repo letöltése
        huggingface-cli download Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17 \
            --local-dir lora-temp \
            --local-dir-use-symlinks False
        
        # LoRA 600
        mkdir -p HUN-600/diffusion_head
        cp lora-temp/diffusion_head600/adapter_config.json HUN-600/
        cp lora-temp/diffusion_head600/model.safetensors HUN-600/diffusion_head/adapter_model.safetensors
        
        # LoRA 900 (LEGJOBB!)
        mkdir -p HUN-900/diffusion_head
        cp lora-temp/diffusion_head900/adapter_config.json HUN-900/
        cp lora-temp/diffusion_head900/model.safetensors HUN-900/diffusion_head/adapter_model.safetensors
        
        # LoRA 1200
        mkdir -p HUN-1200/diffusion_head
        cp lora-temp/diffusion_head1200/adapter_config.json HUN-1200/
        cp lora-temp/diffusion_head1200/model.safetensors HUN-1200/diffusion_head/adapter_model.safetensors
        
        # Cleanup
        rm -rf lora-temp
        
        echo "✅ LoRA-k kész!"
        echo ""
    fi
    
    echo "=========================================="
    echo "✅ MINDEN MODELL LETÖLTVE!"
    echo "=========================================="
    echo ""
fi

# Modellek ellenőrzése
echo "📊 TELEPÍTETT MODELLEK:"
echo ""
echo "📁 Cseti Magyar Modell:"
ls -lh "$CSETI_MODEL" | head -5
echo ""
echo "📁 Tokenizer:"
ls -lh "$TOKENIZER_DIR"
echo ""
echo "📁 LoRA-k:"
ls -d "$LORA_DIR"/HUN-*
echo ""

# ComfyUI indítása
echo "=========================================="
echo "🚀 COMFYUI INDÍTÁSA"
echo "=========================================="
echo ""
echo "🌐 URL: http://0.0.0.0:8188"
echo ""

cd /workspace/ComfyUI
python main.py --listen 0.0.0.0 --port 8188
