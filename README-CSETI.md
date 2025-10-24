# 🇭🇺 CSETI MAGYAR VIBEVOICE TTS - RUNPOD DOCKER

## 🎯 MI EZ?

**Production-ready Docker image** Cseti specialista magyar VibeVoice TTS modelljével RunPod-ra.

### ✨ Cseti Modellek:
- **Fő Modell**: `VibeVoice_7B_hun_v2` (Full Hungarian Finetune)
- **LoRA-k**: HUN-600, HUN-900, HUN-1200 (Mind a 3!)
- **Eredmény**: Szinte tökéletes magyar beszéd generálás! 🚀

---

## 📦 DOCKER IMAGE INFO

```yaml
Docker Hub:     robert777888/vibevoice-comfyui-cseti:v1.0
Alap:           runpod/pytorch:2.1.0-py3.10-cuda11.8.0
Platform:       linux/amd64
Méret:          ~22 GB (OS + Cseti modellek)
GPU Követelmény: 24GB VRAM (RTX 4090 / RTX 3090)
```

---

## 🗂️ TELEPÍTETT MODELLEK

### 🇭🇺 Cseti Magyar Modell (~14 GB):
```
Cseti/VibeVoice_7B_hun_v2
→ LLM: Magyar finomhangolás
→ Diffusion Head: Magyar finomhangolás
→ Merged model (nem kell külön LoRA!)
```

### 🎨 Magyar LoRA-k (Extra finomhangolás):
```
1. HUN-600  (~900 MB) - CommonVoice 17 Hungarian
2. HUN-900  (~900 MB) - CommonVoice 17 Hungarian  
3. HUN-1200 (~900 MB) - CommonVoice 17 Hungarian
```

### 📝 Tokenizer (~11 MB):
```
Qwen/Qwen2.5-1.5B tokenizer
→ KÖTELEZŐ minden VibeVoice modellhez!
```

---

## 🏗️ BUILD INSTRUKCÓK

### 1️⃣ PROJEKT KLÓNOZÁSA

```bash
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice
```

### 2️⃣ DOCKER BUILD (Mac M1/M2/M3)

```bash
# Build (~30-40 perc):
docker build --platform linux/amd64 \
  -f Dockerfile.cseti \
  -t robert777888/vibevoice-comfyui-cseti:v1.0 .

# Tag latest:
docker tag robert777888/vibevoice-comfyui-cseti:v1.0 \
  robert777888/vibevoice-comfyui-cseti:latest
```

### 3️⃣ DOCKER PUSH

```bash
# Először login:
docker login

# Push (~10-15 perc):
docker push robert777888/vibevoice-comfyui-cseti:v1.0
docker push robert777888/vibevoice-comfyui-cseti:latest
```

---

## 🚀 RUNPOD DEPLOYMENT

### 1️⃣ TEMPLATE LÉTREHOZÁSA

```yaml
Name:            Cseti Magyar VibeVoice TTS
Container Image: robert777888/vibevoice-comfyui-cseti:v1.0
Container Disk:  50 GB  # Fontos: 50GB minimum!
Volume Disk:     20 GB  # Opcionális (output-oknak)
Expose Ports:    8188
Environment:     
  - COMFYUI_PORT=8188
```

### 2️⃣ POD INDÍTÁSA

**Ajánlott GPU-k:**
- ✅ **RTX 4090** (24GB VRAM) - LEGJOBB
- ✅ RTX 3090 (24GB VRAM) - Működik
- ✅ A100 (40GB VRAM) - Overkill
- ❌ RTX 3080 (10GB VRAM) - Kevés

**Community Cloud költség:**
- RTX 4090: ~$0.49/óra
- RTX 3090: ~$0.39/óra

### 3️⃣ ELÉRHETŐ URL-EK

```bash
# ComfyUI WebUI:
https://[pod-id]-8188.proxy.runpod.net

# SSH (debug):
ssh root@[pod-id].pod.runpod.io -p [port]
```

---

## 🎨 COMFYUI WORKFLOW

### 📥 Workflow Betöltése:

1. Load workflow: `Hungarian-LoRA-Cseti.json`
2. Vagy építsd fel kézzel:

### 🔧 Node Struktúra:

```
1. LoadAudio (INPUT)
   └─→ Magyar hangminta (.wav, .mp3)

2. VibeVoice Single Speaker (MAIN)
   ├─ model: VibeVoice_7B_hun_v2  ← CSETI MODELL!
   ├─ text: "Magyar szöveg ide..."
   ├─ quantize_llm: 4bit (8GB VRAM-hoz) / none (24GB VRAM-hoz)
   ├─ diffusion_steps: 25
   ├─ cfg_scale: 1.5
   └─ voice_speed_factor: 0.95

3. VibeVoice LoRA (OPTIONAL - Extra minőség)
   ├─ lora_name: HUN-900  ← CSETI SZERINT A LEGJOBB!
   ├─ llm_strength: 2.0
   ├─ use_llm: true
   ├─ use_diffusion_head: true
   ├─ use_acoustic_connector: true
   └─ use_semantic_connector: true

4. SaveAudio (OUTPUT)
   └─→ output/audio/generated.wav
```

---

## ⚙️ OPTIMÁLIS BEÁLLÍTÁSOK

### 🎯 Cseti Modell (Alap):
```yaml
model: VibeVoice_7B_hun_v2
quantize_llm: none        # Ha van 24GB VRAM
# vagy
quantize_llm: 4bit        # Ha csak 12GB VRAM van
attention_type: auto
```

### 🎨 LoRA (Opcionális, Extra Finomhangolás):
```yaml
# Cseti szerint a 900-as a legjobb!
lora_name: HUN-900
llm_strength: 2.0         # Cseti javaslat
use_llm: true
use_diffusion_head: true
use_acoustic_connector: true
use_semantic_connector: true
```

### 🔊 Generálási Beállítások:
```yaml
diffusion_steps: 25       # Kiegyensúlyozott
cfg_scale: 1.5            # Kreativitás/pontosság egyensúly
voice_speed_factor: 0.95  # Természetes tempó
seed: 42                  # Reprodukálható eredmények
```

---

## 📂 DOCKER MAPPA STRUKTÚRA

```
/workspace/ComfyUI/models/vibevoice/
│
├── VibeVoice_7B_hun_v2/           # Cseti fő modell (~14GB)
│   ├── config.json
│   ├── model-00001-of-00003.safetensors
│   ├── model-00002-of-00003.safetensors
│   ├── model-00003-of-00003.safetensors
│   └── ...
│
├── tokenizer/                      # Qwen tokenizer (~11MB)
│   ├── tokenizer_config.json
│   ├── vocab.json
│   ├── merges.txt
│   └── tokenizer.json
│
└── loras/                          # Magyar LoRA-k
    ├── HUN-600/
    │   ├── adapter_config.json
    │   └── diffusion_head/
    │       └── adapter_model.safetensors
    │
    ├── HUN-900/                    # ← CSETI SZERINT A LEGJOBB!
    │   ├── adapter_config.json
    │   └── diffusion_head/
    │       └── adapter_model.safetensors
    │
    └── HUN-1200/
        ├── adapter_config.json
        └── diffusion_head/
            └── adapter_model.safetensors
```

---

## 🎯 VÁRHATÓ EREDMÉNYEK

### ✅ Cseti Modell (VibeVoice_7B_hun_v2):
- Természetes magyar beszéd
- Nincs kínai akcentus
- Tiszta kiejtés
- Jó hanglejtés

### ✅ Cseti Modell + HUN-900 LoRA:
- **SZINTE TÖKÉLETES** magyar beszéd! 🎉
- Erős magyar akcentus
- Természetes ritmus
- Profi minőség

### 📊 Generálási Idők (RTX 4090):
```
25 steps, 4bit quantize:  ~15-20 sec
25 steps, no quantize:    ~20-30 sec
25 steps + LoRA:          ~25-35 sec
```

---

## 🚨 FONTOS MEGJEGYZÉSEK

### ⚠️ Model Verzió:
```bash
# HELYES (Cseti):
VibeVoice_7B_hun_v2  ✅

# RÉGI (ne használd):
VibeVoice-Large-Q8   ❌
```

### ⚠️ LoRA Választás:
```bash
# Cseti szerint (discussion alapján):
HUN-900  → LEGJOBB, legtisztább eredmény! ✅
HUN-1200 → Kicsit túltrenírozott
HUN-600  → Működik, de gyengébb
```

### ⚠️ Quantization:
```yaml
# 24GB VRAM esetén:
quantize_llm: none  # LEGJOBB minőség

# 12-16GB VRAM esetén:
quantize_llm: 4bit  # Jó kompromisszum

# 8GB VRAM esetén:
quantize_llm: 8bit  # Működik, de lassabb
```

---

## 🐛 HIBAELHÁRÍTÁS

### ❌ "Model not found"
```bash
# Ellenőrizd SSH-n keresztül:
ssh root@[pod-id].pod.runpod.io -p [port]

ls -lh /workspace/ComfyUI/models/vibevoice/
# Kell lennie: VibeVoice_7B_hun_v2/ mappának!
```

### ❌ "LoRA not found"
```bash
# Ellenőrizd:
ls -lh /workspace/ComfyUI/models/vibevoice/loras/
# Kell lennie: HUN-600/, HUN-900/, HUN-1200/
```

### ❌ "Out of Memory"
```yaml
# Megoldás 1: Quantize
quantize_llm: 4bit

# Megoldás 2: Kevesebb steps
diffusion_steps: 20  # 25 helyett

# Megoldás 3: Ne használj LoRA-t
# (A Cseti modell önmagában is jó!)
```

---

## 📚 FORRÁSOK ÉS KÖSZÖNETNYILVÁNÍTÁS

### 🇭🇺 Cseti Modelljei:
- [VibeVoice_7B_hun_v2](https://huggingface.co/Cseti/VibeVoice_7B_hun_v2)
- [Magyar LoRA-k](https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17)
- [ComfyUI Diskusszió](https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17/discussions/1)

### 🛠️ Használt Eszközök:
- [VibeVoice](https://github.com/vibevoice-community/VibeVoice)
- [VibeVoice ComfyUI](https://github.com/Enemyx-net/VibeVoice-ComfyUI)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [RunPod](https://www.runpod.io/)

### 🙏 Köszönet:
- **Cseti** - Magyar modellek és LoRA-k
- **Enemyx** - ComfyUI node
- **JPGallegoar** - VibeVoice finetuning code

---

## 📋 BUILD CHECKLIST

```bash
# ✅ Előkészítés
- [ ] Docker Desktop fut
- [ ] Docker Hub login
- [ ] 30GB+ szabad hely

# ✅ Build
- [ ] cd projekt mappába
- [ ] docker build ... (30-40 perc)
- [ ] docker images | grep cseti (ellenőrzés)

# ✅ Push
- [ ] docker push v1.0
- [ ] docker push latest

# ✅ RunPod
- [ ] Template létrehozva (50GB disk!)
- [ ] Pod indítva (RTX 4090)
- [ ] ComfyUI elérhető (:8188)

# ✅ Teszt
- [ ] Workflow betöltve
- [ ] Magyar szöveg beírva
- [ ] Queue Prompt
- [ ] Audio lejátszás ✨
```

---

## 🎉 PÉLDA SZÖVEGEK (Cseti tesztjei alapján)

### 1. Természetes beszéd:
```
"Az utcák lassan megteltek emberekkel, ahogy a város ébredezett.
A kávézók teraszain gőzölgő csészék mellett beszélgettek az emberek."
```

### 2. Nehéz magánhangzók:
```
"Őrült űző üldöző őz őrjöngő őrült őrzőjével ügető ürge üvöltözött."
```

### 3. Cs/C kiejtés teszt:
```
"Csapzott cserecsapat cserebogár csapongott cserepes cseresznyecsokrok csücskében."
```

---

## 🚀 GYORS START

```bash
# 1. Build
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice
docker build --platform linux/amd64 -f Dockerfile.cseti \
  -t robert777888/vibevoice-comfyui-cseti:v1.0 .

# 2. Push
docker push robert777888/vibevoice-comfyui-cseti:v1.0

# 3. RunPod Template
Container: robert777888/vibevoice-comfyui-cseti:v1.0
Disk: 50GB
GPU: RTX 4090

# 4. ComfyUI
Model: VibeVoice_7B_hun_v2
LoRA: HUN-900 (strength: 2.0)
Steps: 25

# 5. Élvezd a tökéletes magyar TTS-t! 🎉🇭🇺
```

---

**Made with ❤️ for Hungarian TTS**

**Köszönet Cseti munkájáért! 🙏**
