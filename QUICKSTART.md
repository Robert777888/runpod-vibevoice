# 🚀 GYORS INDÍTÁS - CSETI MAGYAR TTS

## ⚡ 5 PERCES QUICK START

### 1️⃣ TERMINÁL MEGNYITÁSA

```bash
# Mac Spotlight: Cmd+Space → "Terminal"
```

### 2️⃣ PROJEKT MAPPA

```bash
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice
```

### 3️⃣ BUILD SCRIPT FUTTATÁSA

```bash
# Executable-é tétel:
chmod +x build_cseti.sh

# Build indítása:
./build_cseti.sh
```

**Vagy manuálisan:**

```bash
docker build --platform linux/amd64 \
  -f Dockerfile.cseti \
  -t robert777888/vibevoice-comfyui-cseti:v1.0 .
```

### 4️⃣ PUSH DOCKER HUB-RA

```bash
# Login (ha kell):
docker login

# Push:
docker push robert777888/vibevoice-comfyui-cseti:v1.0
docker push robert777888/vibevoice-comfyui-cseti:latest
```

---

## 🔥 MÉG GYORSABB (1 parancs)

```bash
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice && \
docker build --platform linux/amd64 -f Dockerfile.cseti -t robert777888/vibevoice-comfyui-cseti:v1.0 . && \
docker tag robert777888/vibevoice-comfyui-cseti:v1.0 robert777888/vibevoice-comfyui-cseti:latest && \
docker push robert777888/vibevoice-comfyui-cseti:v1.0 && \
docker push robert777888/vibevoice-comfyui-cseti:latest && \
echo "🎉 KÉSZ!"
```

---

## 📋 FÁJLOK ÖSSZEFOGLALÁSA

### ✅ BUILD-hez Kell:
```
Dockerfile.cseti          → Docker konfiguráció
start.sh                  → ComfyUI indító
```

### 📖 DOKUMENTÁCIÓ:
```
README-CSETI.md          → Teljes dokumentáció
PROJECT-STATUS-CSETI.md  → Projekt státusz
COMPARISON.md            → Verzió összehasonlítás
QUICKSTART.md            → Ez a fájl
```

### 🎨 WORKFLOW:
```
Hungarian-LoRA-Cseti.json → ComfyUI workflow
```

### 🤖 SCRIPT:
```
build_cseti.sh           → Automata build script
```

---

## ⏱️ VÁRHATÓ IDŐSZÜKSÉGLET

```
Docker Build:   30-40 perc
Docker Push:    10-15 perc
TOTAL:         40-55 perc

→ Indítsd el, menj kávézni! ☕
```

---

## 🎯 RUNPOD TEMPLATE (Copy-Paste)

### Template Settings:
```yaml
Name:            Cseti Magyar VibeVoice TTS
Container Image: robert777888/vibevoice-comfyui-cseti:v1.0
Container Disk:  50 GB
Volume Disk:     20 GB (optional)
Expose HTTP:     8188
GPU:             RTX 4090 (24GB VRAM)
```

### Environment Variables:
```
COMFYUI_PORT=8188
```

---

## 🔗 HASZNOS LINKEK

### Docker Hub:
```
https://hub.docker.com/r/robert777888/vibevoice-comfyui-cseti
```

### Cseti Modellek:
```
https://huggingface.co/Cseti/VibeVoice_7B_hun_v2
https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17
```

### RunPod:
```
https://www.runpod.io/
```

---

## 🎨 COMFYUI HASZNÁLAT

### 1. Workflow Betöltése:
```
1. Nyisd meg ComfyUI-t: https://[pod-id]-8188.proxy.runpod.net
2. Load workflow: Hungarian-LoRA-Cseti.json
```

### 2. Beállítások:
```yaml
Model:          VibeVoice_7B_hun_v2
LoRA:           HUN-900
Text:           "Magyar szöveg ide..."
Quantize:       none (vagy 4bit ha kevés VRAM)
Steps:          25
CFG:            1.5
Voice Speed:    0.95
```

### 3. Generálás:
```
1. LoadAudio: Tölts fel magyar hangmintát
2. Írd be a magyar szöveget
3. Queue Prompt
4. Várd meg (~25 sec)
5. Lejátszás! 🎉
```

---

## 🐛 GYORS HIBAELHÁRÍTÁS

### ❌ "Docker not running"
```bash
# Megoldás: Indítsd el Docker Desktop-ot
open -a Docker
```

### ❌ "No space left"
```bash
# Ellenőrizd:
df -h

# Takarítás:
docker system prune -a
```

### ❌ "Permission denied"
```bash
# Megoldás:
chmod +x build_cseti.sh
```

### ❌ "Model not found" (RunPod-on)
```bash
# SSH ellenőrzés:
ssh root@[pod-id].pod.runpod.io -p [port]
ls -lh /workspace/ComfyUI/models/vibevoice/
```

---

## 📊 ELLENŐRZŐ LISTA

### Build Előtt:
- [ ] Docker Desktop fut
- [ ] 30GB+ szabad hely
- [ ] Docker Hub login OK
- [ ] cd projekt mappába

### Build Után:
- [ ] Image ~22GB
- [ ] docker images | grep cseti
- [ ] Push sikeres
- [ ] Docker Hub-on látható

### RunPod:
- [ ] Template létrehozva (50GB!)
- [ ] Pod indítva (RTX 4090)
- [ ] ComfyUI elérhető
- [ ] Workflow betöltve
- [ ] Model: VibeVoice_7B_hun_v2
- [ ] LoRA: HUN-900 listában

### Teszt:
- [ ] Magyar szöveg beírva
- [ ] Queue Prompt
- [ ] Generálás sikeres
- [ ] Audio lejátszás
- [ ] ✅ Tökéletes magyar hang!

---

## 🎉 ELSŐ TESZT SZÖVEG

```
"Szia! Ez egy teszt szöveg magyarul. 
Az utcák lassan megteltek emberekkel, 
ahogy a város ébredezett. 
A kávézók teraszain gőzölgő csészék mellett 
beszélgettek az emberek."
```

---

## 💡 PRO TIPPEK

### 1. Gyorsabb Build:
```bash
# Cache használata:
docker build --cache-from robert777888/vibevoice-comfyui-cseti:latest ...
```

### 2. Build Progress:
```bash
# Részletes output:
docker build --progress=plain ...
```

### 3. Storage Takarítás:
```bash
# Build után:
docker system prune -a

# Vagy csak cache:
docker builder prune
```

### 4. Local Teszt (Optional):
```bash
docker run -it --rm -p 8188:8188 \
  robert777888/vibevoice-comfyui-cseti:v1.0
```

---

## 🚀 KÖVETKEZŐ LÉPÉS

### HA BUILD-ELNI AKARSZ:
```bash
chmod +x build_cseti.sh
./build_cseti.sh
```

### HA CSAK HASZNÁLNI AKAROD:
```
1. Menj RunPod-ra
2. Új Template: robert777888/vibevoice-comfyui-cseti:v1.0
3. Pod indítás (RTX 4090, 50GB)
4. ComfyUI → Hungarian-LoRA-Cseti.json
5. Enjoy! 🎉
```

---

## 📞 SEGÍTSÉG

### Dokumentáció:
```
README-CSETI.md          → Teljes leírás
PROJECT-STATUS-CSETI.md  → Státusz
COMPARISON.md            → Összehasonlítás
```

### Cseti Discussion:
```
https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17/discussions/1
```

---

## ✨ ÖSSZEFOGLALÁS

```
3 EGYSZERŰ LÉPÉS:

1️⃣  chmod +x build_cseti.sh && ./build_cseti.sh
2️⃣  RunPod Template (50GB, RTX 4090)
3️⃣  ComfyUI → Hungarian-LoRA-Cseti.json

EREDMÉNY: 🇭🇺 TÖKÉLETES MAGYAR TTS! 🎉
```

---

**GYERÜNK, CSINÁLJUK MEG! 💪🚀**

**Made with ❤️ using Cseti's amazing work! 🙏**
