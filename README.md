# 🎙️ VibeVoice ComfyUI - RunPod Docker Image

Magyar TTS (Text-to-Speech) rendszer ComfyUI-ban, VibeVoice 7B modellel és magyar LoRA-val.

## 🚀 Gyors Indítás

### 1️⃣ Docker Image Build

```bash
# Mac-en (local build):
cd /Users/robertkispal/PycharmProjects/text_to_speech/runpod-vibevoice

docker build --platform linux/amd64 -t robert777888/vibevoice-comfyui:latest .
docker push robert777888/vibevoice-comfyui:latest
```

### 2️⃣ RunPod Deployment

1. **Template létrehozása:**
   - Container Image: `robert777888/vibevoice-comfyui:latest`
   - Container Disk: 40 GB
   - Expose HTTP Ports: `8188` (ComfyUI)
   - GPU: RTX 4090 vagy A100 (24GB+ VRAM)

2. **Pod indítása:**
   - Template kiválasztása
   - GPU típus: RTX 4090 (24GB VRAM)
   - Start Pod

3. **Hozzáférés:**
   - ComfyUI: `https://[pod-id]-8188.proxy.runpod.net`

---

## 📦 Tartalma

### Modellek (Előre Letöltve):

| Model | Méret | Hely | Leírás |
|-------|-------|------|--------|
| **VibeVoice-Large-Q8** | 11.6GB | `/workspace/ComfyUI/models/vibevoice/VibeVoice-Large-Q8/` | 8-bit kvantált modell |
| **Qwen Tokenizer** | 11MB | `/workspace/ComfyUI/models/vibevoice/tokenizer/` | KÖTELEZŐ tokenizer |
| **Magyar LoRA (HUN-1200)** | 2.8GB | `/workspace/ComfyUI/models/vibevoice/loras/HUN-1200/` | Magyar diffusion head |

**Teljes méret:** ~15 GB (modellek + dependencies)

---

## 🎯 Workflow Setup

### Alapértelmezett Workflow (Magyar LoRA-val):

```
1. LoadAudio
   └─ Tölts fel magyar hangmintát (10-30 sec)

2. VibeVoice LoRA
   ├─ lora_name: HUN-1200
   ├─ llm_strength: 2.0
   └─ Kapcsold a VibeVoice Single Speaker node-hoz

3. VibeVoice Single Speaker
   ├─ voice_to_clone: LoadAudio output
   ├─ lora: VibeVoice LoRA output
   ├─ text: "Magyar szöveg..."
   ├─ model: VibeVoice-Large-Q8
   ├─ quantize_llm: 8bit
   ├─ diffusion_steps: 25
   └─ cfg_scale: 1.5

4. PreviewAudio
   └─ Hallgasd meg az eredményt!
```

### Workflow JSON-ök:

- `Hungarian-LoRA-FIXED.json` - Magyar LoRA-val
- `Single-Speaker-Working-NO-LoRA.json` - LoRA nélkül

---

## 🔧 Beállítások Finomhangolása

### Magyar Kiejtés Erőssége:

```
llm_strength: 1.0-1.5  → Gyenge magyar akcentus
llm_strength: 1.5-2.0  → Közepes (AJÁNLOTT)
llm_strength: 2.0-2.5  → Erős magyar kiejtés
```

### Minőség vs Sebesség:

```
diffusion_steps: 20    → Gyorsabb (~15 sec)
diffusion_steps: 25    → Kiegyensúlyozott (AJÁNLOTT)
diffusion_steps: 30    → Jobb minőség (~25 sec)
```

### CFG Scale (Kreativitás):

```
cfg_scale: 1.3-1.5     → Konzervatív, pontosabb
cfg_scale: 1.5-1.7     → Kiegyensúlyozott (AJÁNLOTT)
cfg_scale: 1.7-2.0     → Kreatívabb, változatosabb
```

---

## 📂 Mappa Struktúra

```
/workspace/ComfyUI/
├── models/
│   └── vibevoice/
│       ├── VibeVoice-Large-Q8/      # Q8 model
│       ├── tokenizer/                # Tokenizer (KÖTELEZŐ!)
│       └── loras/                    # LoRA-k (nem "lora"!)
│           └── HUN-1200/             # Magyar LoRA
│               ├── adapter_config.json
│               ├── adapter_model.safetensors
│               ├── config.json
│               ├── model.safetensors
│               └── diffusion_head/
├── input/
│   └── audio/                        # Hangminták ide
├── output/
│   └── audio/                        # Generált audió
└── custom_nodes/
    └── VibeVoice-ComfyUI/           # VibeVoice node
```

---

## 🐛 Hibaelhárítás

### 1. "No models found"
```bash
# Ellenőrizd a modelleket:
ls -la /workspace/ComfyUI/models/vibevoice/VibeVoice-Large-Q8/

# Ha üres, építsd újra a Docker image-t
```

### 2. "LoRA not found" vagy csak 'None' látszik
```bash
# Ellenőrizd a LoRA helyet:
ls -la /workspace/ComfyUI/models/vibevoice/loras/HUN-1200/

# FONTOS: "loras" nem "lora"!
# Kell látni: adapter_config.json, adapter_model.safetensors
```

### 3. "Invalid UUID" hiba workflow betöltésnél
```
Használd a javított JSON fájlokat:
- Hungarian-LoRA-FIXED.json
- Single-Speaker-Working-NO-LoRA.json
```

### 4. Akcentusos magyar hang (gyenge LoRA)
```
Növeld az llm_strength értékét:
1.5 → 2.0 → 2.5
```

---

## 💾 VRAM Igények

| GPU | VRAM | Model | Quantization | Működik? |
|-----|------|-------|--------------|----------|
| RTX 3090 | 24GB | Q8 | 8bit | ✅ Igen |
| RTX 4090 | 24GB | Q8 | 8bit | ✅ Igen (AJÁNLOTT) |
| A100 | 40GB | Q8 | 8bit | ✅ Igen |
| RTX 3080 | 10GB | Q8 | 8bit | ❌ Nem elég |

---

## 📝 Változások (Latest)

### v1.1 (2025-10-22)
- ✅ LoRA mappa javítva: `loras/` helyett `lora/`
- ✅ LoRA struktúra javítva: `diffusion_head1200` tartalom közvetlenül `HUN-1200/` alatt
- ✅ Tokenizer letöltés hozzáadva (KÖTELEZŐ!)
- ✅ Dockerfile optimalizálva
- ✅ Magyar LoRA (HUN-1200) előre telepítve

### v1.0 (2025-10-21)
- 🎉 Első verzió
- VibeVoice-Large-Q8 modell
- ComfyUI alaprendszer

---

## 🔗 Hasznos Linkek

- [VibeVoice GitHub](https://github.com/microsoft/VibeVoice)
- [VibeVoice-ComfyUI Node](https://github.com/Enemyx-net/VibeVoice-ComfyUI)
- [VibeVoice Q8 Model](https://huggingface.co/FabioSarracino/VibeVoice-Large-Q8)
- [Magyar LoRA](https://huggingface.co/Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17)
- [Qwen Tokenizer](https://huggingface.co/Qwen/Qwen2.5-1.5B)

---

## 📄 Licenc

MIT License

---

## 👤 Szerző

Robert Kispal (@robert777888)

---

## 🙏 Köszönet

- Microsoft VibeVoice csapat
- Enemyx-net (VibeVoice-ComfyUI)
- Cseti (Magyar LoRA)
- RunPod közösség
