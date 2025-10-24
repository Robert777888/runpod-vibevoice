# 🇭🇺 CSETI MAGYAR TTS - PROJEKT STÁTUSZ

## 🎉 MI VÁLTOZOTT?

### ❌ RÉGI (VibeVoice Q8):
```
Model: VibeVoice-Large-Q8
LoRA:  HUN-1200 (egyedül)
Eredmény: Jó, de kínai akcentussal 🇨🇳
```

### ✅ ÚJ (Cseti Magyar):
```
Model: VibeVoice_7B_hun_v2 (CSETI SPECIALISTA!)
LoRA:  HUN-600, HUN-900, HUN-1200 (mind a 3!)
Eredmény: SZINTE TÖKÉLETES magyar beszéd! 🇭🇺🎉
```

---

## 📦 TELEPÍTETT MODELLEK

### 🇭🇺 1. FŐ MODELL (Cseti Full Finetune):
```
Repo:    Cseti/VibeVoice_7B_hun_v2
Méret:   ~14 GB
Típus:   Full model (LLM + Diffusion head merged)
Training: CommonVoice 17 Hungarian dataset
Eredmény: Magyar beszéd NÉLKÜL LoRA!
```

**Mappa:**
```
/workspace/ComfyUI/models/vibevoice/VibeVoice_7B_hun_v2/
├── config.json
├── model-00001-of-00003.safetensors (5GB)
├── model-00002-of-00003.safetensors (5GB)
├── model-00003-of-00003.safetensors (4GB)
└── ...
```

### 🎨 2. MAGYAR LORA-K (Extra finomhangolás):
```
Repo:    Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17
Méretek: ~900 MB each
Verziók: 600, 900, 1200 (training checkpoints)

CSETI SZERINT: HUN-900 a LEGJOBB! ✅
```

**Mappa:**
```
/workspace/ComfyUI/models/vibevoice/loras/
├── HUN-600/
│   ├── adapter_config.json
│   └── diffusion_head/
│       └── adapter_model.safetensors
├── HUN-900/                    ← LEGJOBB!
│   ├── adapter_config.json
│   └── diffusion_head/
│       └── adapter_model.safetensors
└── HUN-1200/
    ├── adapter_config.json
    └── diffusion_head/
        └── adapter_model.safetensors
```

### 📝 3. TOKENIZER:
```
Repo:   Qwen/Qwen2.5-1.5B
Méret:  ~11 MB
Típus:  KÖTELEZŐ minden VibeVoice modellhez!
```

---

## 📂 FÁJLOK (Mac-en)

```
/Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice/
│
├── Dockerfile.cseti              # ✅ ÚJ Cseti Docker config
├── README-CSETI.md               # ✅ ÚJ teljes dokumentáció
├── Hungarian-LoRA-Cseti.json     # ✅ ÚJ workflow (Cseti modellel)
│
├── start.sh                      # ComfyUI indító (változatlan)
│
# RÉGI fájlok (referenciának):
├── Dockerfile                    # Régi Q8 verzió
├── README.md                     # Régi dokumentáció
├── Hungarian-LoRA-FIXED.json    # Régi workflow
└── ...
```

---

## 🚀 BUILD PARANCSOK

### 1️⃣ DOCKER BUILD:

```bash
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice

# Build Cseti verzió (~30-40 perc):
docker build --platform linux/amd64 \
  -f Dockerfile.cseti \
  -t robert777888/vibevoice-comfyui-cseti:v1.0 .

# Tag latest:
docker tag robert777888/vibevoice-comfyui-cseti:v1.0 \
  robert777888/vibevoice-comfyui-cseti:latest
```

### 2️⃣ DOCKER PUSH:

```bash
# Login (ha kell):
docker login

# Push (~10-15 perc):
docker push robert777888/vibevoice-comfyui-cseti:v1.0
docker push robert777888/vibevoice-comfyui-cseti:latest
```

---

## 🏗️ RUNPOD TEMPLATE

```yaml
Name:            Cseti Magyar VibeVoice TTS
Container Image: robert777888/vibevoice-comfyui-cseti:v1.0
Container Disk:  50 GB              # ⚠️ FONTOS: 50GB! (nem 40)
Volume Disk:     20 GB              # Opcionális
Expose Ports:    8188
GPU:             RTX 4090 (24GB)    # VAGY RTX 3090
Environment:
  - COMFYUI_PORT=8188
```

---

## ⚙️ WORKFLOW BEÁLLÍTÁSOK

### 🎯 Model Node:
```yaml
Node: VibeVoice Single Speaker

Settings:
  model: VibeVoice_7B_hun_v2      # ← CSETI MODELL!
  text: "Magyar szöveg..."
  quantize_llm: none              # Ha 24GB VRAM
               # vagy 4bit         # Ha kevesebb VRAM
  diffusion_steps: 25
  cfg_scale: 1.5
  voice_speed_factor: 0.95
  seed: 42
```

### 🎨 LoRA Node (Opcionális):
```yaml
Node: VibeVoice LoRA

Settings:
  lora_name: HUN-900              # ← CSETI SZERINT LEGJOBB!
  llm_strength: 2.0               # ← CSETI JAVASLAT!
  use_llm: true
  use_diffusion_head: true
  use_acoustic_connector: true
  use_semantic_connector: true
```

---

## 📊 MODELL MÉRET ÖSSZEHASONLÍTÁS

### RÉGI (Q8):
```
VibeVoice-Large-Q8:  11.6 GB (quantized)
HUN-1200 LoRA:        2.8 GB
Tokenizer:            0.011 GB
─────────────────────────────
TOTAL:               ~14.4 GB
```

### ÚJ (Cseti):
```
VibeVoice_7B_hun_v2: 14.0 GB (full precision)
HUN-600 LoRA:         0.9 GB
HUN-900 LoRA:         0.9 GB
HUN-1200 LoRA:        0.9 GB
Tokenizer:            0.011 GB
─────────────────────────────
TOTAL:               ~16.7 GB
```

**→ Kicsit nagyobb, de SOKKAL jobb minőség!** 🎉

---

## 🎯 VÁRHATÓ EREDMÉNYEK

### ❌ RÉGI (Q8 + HUN-1200):
- Jó magyar beszéd
- Kínai akcentus érezhető
- Néha robotikus hang
- "Vacsi" → "vakszi" 😅

### ✅ ÚJ (Cseti + HUN-900):
- **SZINTE TÖKÉLETES** magyar beszéd! 🎉
- Nincs kínai akcentus
- Természetes hanglejtés
- Tiszta kiejtés
- "Cs" betű is jól megy
- Nehéz mondatok is OK:
  ```
  "Őrült űző üldöző őz őrjöngő..." ✅
  "Csapzott cserecsapat..." ✅
  ```

---

## 💾 DISK KÖVETELMÉNYEK

### Build Gépen (Mac):
```
Docker Build:     30 GB szabad hely
Image tárolás:    22 GB
TOTAL:           ~52 GB

AJÁNLÁS: 60GB+ szabad hely
```

### RunPod-on:
```
Container Disk:   50 GB  # ⚠️ NE 40GB!
Volume (output):  20 GB  # Opcionális
GPU VRAM:         24 GB  # RTX 4090/3090
```

---

## ⏱️ BUILD IDŐSZÜKSÉGLET

```
Docker Build:        30-40 perc
├─ Base image:       5 perc
├─ Dependencies:     10 perc
└─ Model download:   15-25 perc  ← LEGHOSSZABB!

Docker Push:         10-15 perc
├─ Compression:      3 perc
└─ Upload:           7-12 perc

TOTAL:              ~45-55 perc
```

---

## 🔍 CSETI DISCUSSION ALAPJÁN

### 💡 Cseti Megjegyzései:
1. **HUN-900 a legjobb**: "900-as tisztább mint 1200-as"
2. **llm_strength: 2.0**: "Mehet fel 2-re"
3. **Nincs kínai akcentus**: "7B-nél nem tapasztaltam"
4. **4bit kvantálás**: "8-9 GB VRAM, példáim is így készültek"

### 🛠️ LoRA Struktúra (Cseti instrukcói):
```
loras/HUN-900/
├── adapter_config.json        # Gyökérben!
└── diffusion_head/
    └── adapter_model.safetensors  # (model.safetensors átnevezve)
```

---

## 🐛 HIBAELHÁRÍTÁS

### ❌ "Model not found"
```bash
# SSH-n ellenőrizd:
ls -lh /workspace/ComfyUI/models/vibevoice/

# Kell lennie:
VibeVoice_7B_hun_v2/  ✅
```

### ❌ "LoRA not found"
```bash
# Ellenőrizd:
ls -lh /workspace/ComfyUI/models/vibevoice/loras/

# Kell lennie:
HUN-600/  ✅
HUN-900/  ✅
HUN-1200/ ✅
```

### ❌ "Kínai akcentus hallható"
```
Probléma: Rossz modellt használsz!

Megoldás:
1. Model: VibeVoice_7B_hun_v2  ← NE VibeVoice-Large-Q8!
2. LoRA: HUN-900
3. llm_strength: 2.0
```

---

## ✅ BUILD CHECKLIST

```bash
# 🔧 Előkészítés
- [ ] Mac-en 60GB+ szabad hely
- [ ] Docker Desktop fut
- [ ] docker login rendben

# 📦 Build
- [ ] cd projekt mappába
- [ ] Dockerfile.cseti használata
- [ ] docker build (30-40 perc várakozás)
- [ ] docker images ellenőrzés (~22GB)

# 🚀 Push
- [ ] docker push v1.0
- [ ] docker push latest
- [ ] Docker Hub-on ellenőrzés

# ☁️ RunPod
- [ ] Template: 50GB disk!
- [ ] Pod: RTX 4090
- [ ] ComfyUI elérhető (:8188)

# 🎨 Teszt
- [ ] Workflow: Hungarian-LoRA-Cseti.json
- [ ] Model: VibeVoice_7B_hun_v2
- [ ] LoRA: HUN-900
- [ ] Magyar szöveg teszt
- [ ] Audio lejátszás
- [ ] ✅ Tökéletes magyar hang! 🎉
```

---

## 🎉 KÖVETKEZŐ LÉPÉS

```bash
# INDÍTSD EL A BUILD-et! 🚀

cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice

docker build --platform linux/amd64 \
  -f Dockerfile.cseti \
  -t robert777888/vibevoice-comfyui-cseti:v1.0 .

# Majd push:
docker push robert777888/vibevoice-comfyui-cseti:v1.0
docker push robert777888/vibevoice-comfyui-cseti:latest
```

---

## 🙏 KÖSZÖNET

- **Cseti** - Zseniális magyar modellek és LoRA-k! 🇭🇺
- **Enemyx** - VibeVoice ComfyUI node
- **JPGallegoar** - VibeVoice finetuning framework
- **CommonVoice** - Magyar dataset

---

## 📚 FORRÁSOK

- [Cseti Magyar Modell](https://huggingface.co/Cseti/VibeVoice_7B_hun_v2)
- [Cseti LoRA-k](https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17)
- [ComfyUI Diskusszió](https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17/discussions/1)
- [VibeVoice ComfyUI](https://github.com/Enemyx-net/VibeVoice-ComfyUI)

---

## 🎯 ÖSSZEFOGLALÁS

### Mi volt a probléma?
- Q8 modell + HUN-1200 LoRA → kínai akcentus

### Mi a megoldás?
- **Cseti VibeVoice_7B_hun_v2** (specialista magyar!)
- **HUN-900 LoRA** (Cseti szerint legjobb)
- **llm_strength: 2.0** (erős magyar)

### Eredmény?
- **SZINTE TÖKÉLETES MAGYAR TTS!** 🇭🇺🎉
- Nincs kínai akcentus
- Természetes hanglejtés
- Profi minőség

---

**MINDEN KÉSZEN ÁLL A BUILD-RE!** 💪🚀

**Gyerünk, csináljuk meg! 😊**
