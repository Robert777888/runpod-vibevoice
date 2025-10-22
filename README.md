# 🎙️ VibeVoice ComfyUI - RunPod Template

**Magyar hangklónozás ComfyUI-ban, RunPod-on futtatva. Teljes automatizált setup!**

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![RunPod](https://img.shields.io/badge/RunPod-6E3FF3?style=for-the-badge)](https://runpod.io/)
[![ComfyUI](https://img.shields.io/badge/ComfyUI-FF6B6B?style=for-the-badge)](https://github.com/comfyanonymous/ComfyUI)

## ⚡ Gyors Start (3 lépésben)

### 1️⃣ Fork vagy Clone

```bash
git clone https://github.com/YOURNAME/runpod-vibevoice.git
cd runpod-vibevoice
```

### 2️⃣ Build & Push

```bash
chmod +x build_and_push.sh
./build_and_push.sh your_dockerhub_username
```

### 3️⃣ RunPod Deploy

1. Menj: https://www.runpod.io/console/pods
2. **New Template**
3. **Container Image**: `your_dockerhub_username/vibevoice-comfyui:latest`
4. **Container Disk**: `50GB`
5. **Expose Ports**: `8188`
6. **Deploy Pod**

**Kész! 🎉 Nyisd meg a Port 8188 linket és használd a ComfyUI-t!**

---

## 📋 Mi van benne?

- ✅ **ComfyUI** - Vizuális workflow editor
- ✅ **VibeVoice 7B** - Alap TTS modell
- ✅ **Magyar LoRA** - Hungarian CV17 Diffusion Head
- ✅ **Automatikus setup** - Minden előre konfigurálva
- ✅ **Ready-to-use workflow** - Importálható JSON
- ✅ **Docker + Docker Compose** - Lokális teszteléshez

---

## 🚀 GYORS START (Helyi Teszt)

```bash
# 1. Lépj be a mappába
cd runpod-vibevoice

# 2. Adj futtatási jogot a scriptnek
chmod +x quick_setup.sh

# 3. Futtasd
./quick_setup.sh

# 4. Nyisd meg böngészőben
# http://localhost:8188
```

---

## 💰 Költségbecslés (RunPod)

| GPU | $/óra | 10s generálás |
|-----|-------|--------------|
| RTX 3090 | $0.50 | ~25s |
| RTX 4090 | $0.75 | ~20s |

**100 klip = ~$0.40**

---

## 🔗 Hasznos Linkek

- **ComfyUI**: https://github.com/comfyanonymous/ComfyUI
- **VibeVoice**: https://github.com/Enemyx-net/VibeVoice-ComfyUI
- **Magyar Model**: https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17
- **RunPod**: https://www.runpod.io/

---

**Made with ❤️ | v1.0.0**
