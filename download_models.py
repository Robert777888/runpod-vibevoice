#!/usr/bin/env python3
"""
VibeVoice Modellek Letöltése - Python verzió
Használat: python download_models.py
"""

from huggingface_hub import hf_hub_download, snapshot_download
import os
from pathlib import Path

# Alapkönyvtár
BASE_DIR = Path("/workspace/ComfyUI/models/VibeVoice")
BASE_MODEL_DIR = BASE_DIR / "base_model"
LORA_DIR = BASE_DIR / "diffusion_head" / "hungarian"

def download_base_model():
    """Base model letöltése (Q8 - GGUF)"""
    print("📥 BASE MODEL letöltése (Q8 - ~6.5GB)...")
    
    # Mappa létrehozása
    BASE_MODEL_DIR.mkdir(parents=True, exist_ok=True)
    
    try:
        hf_hub_download(
            repo_id="vibeai/vibevoice-7b-base-v1",
            filename="vibevoice-7b-base-v1.Q8_0.gguf",
            local_dir=str(BASE_MODEL_DIR),
            local_dir_use_symlinks=False
        )
        print("✅ BASE MODEL letöltve!")
        return True
    except Exception as e:
        print(f"❌ Hiba BASE MODEL letöltésekor: {e}")
        return False

def download_magyar_lora():
    """Magyar LoRA letöltése"""
    print("📥 MAGYAR LoRA letöltése (~2-3GB)...")
    
    # Mappa létrehozása
    LORA_DIR.mkdir(parents=True, exist_ok=True)
    
    try:
        snapshot_download(
            repo_id="Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17",
            allow_patterns="diffusion_head1200/*",
            local_dir=str(LORA_DIR),
            local_dir_use_symlinks=False
        )
        print("✅ MAGYAR LoRA letöltve!")
        return True
    except Exception as e:
        print(f"❌ Hiba MAGYAR LoRA letöltésekor: {e}")
        return False

def verify_downloads():
    """Ellenőrzi a letöltött fájlokat"""
    print("\n🔍 Letöltött fájlok ellenőrzése...")
    
    # Base model
    base_model_file = BASE_MODEL_DIR / "vibevoice-7b-base-v1.Q8_0.gguf"
    if base_model_file.exists():
        size_gb = base_model_file.stat().st_size / (1024**3)
        print(f"✅ Base model: {size_gb:.2f} GB")
    else:
        print("❌ Base model hiányzik!")
    
    # LoRA fájlok
    lora_files = list(LORA_DIR.rglob("*"))
    if lora_files:
        print(f"✅ Magyar LoRA: {len(lora_files)} fájl")
        for file in lora_files:
            if file.is_file():
                size_mb = file.stat().st_size / (1024**2)
                print(f"   - {file.name}: {size_mb:.2f} MB")
    else:
        print("❌ Magyar LoRA hiányzik!")

def main():
    """Fő függvény"""
    print("🚀 VibeVoice Modellek Letöltése - Python verzió\n")
    
    # Ellenőrzés: létezik-e a könyvtár
    if not Path("/workspace/ComfyUI").exists():
        print("❌ Hiba: /workspace/ComfyUI nem található!")
        print("   Biztos, hogy ComfyUI telepítve van?")
        return
    
    # Base model letöltés
    base_success = download_base_model()
    
    # Magyar LoRA letöltés
    lora_success = download_magyar_lora()
    
    # Ellenőrzés
    print()
    verify_downloads()
    
    # Összefoglalás
    print("\n" + "="*50)
    if base_success and lora_success:
        print("🎉 MINDEN MODELL SIKERESEN LETÖLTVE!")
        print("⚠️  Ne felejts el újraindítani a ComfyUI-t!")
    else:
        print("⚠️  Néhány modell letöltése sikertelen!")
        print("   Próbáld újra vagy használd a CLI verziót.")
    print("="*50)

if __name__ == "__main__":
    main()
