FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

# Munkakörnyezet beállítása
WORKDIR /workspace

# Rendszer csomagok telepítése
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    vim \
    ffmpeg \
    libsndfile1 \
    git-lfs \
    && git lfs install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python függőségek telepítése
RUN pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 \
    transformers>=4.30.0 \
    accelerate>=0.20.0 \
    xformers \
    soundfile \
    librosa \
    scipy \
    pydub \
    huggingface-hub[cli] \
    gradio \
    fastapi \
    uvicorn

# ComfyUI klónozása
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# ComfyUI függőségek telepítése
WORKDIR /workspace/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# VibeVoice Custom Node telepítése
WORKDIR /workspace/ComfyUI/custom_nodes
RUN git clone https://github.com/Enemyx-net/VibeVoice-ComfyUI.git

# VibeVoice függőségek telepítése
WORKDIR /workspace/ComfyUI/custom_nodes/VibeVoice-ComfyUI
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Mappastruktúra létrehozása
WORKDIR /workspace/ComfyUI
RUN mkdir -p models/VibeVoice/diffusion_head \
    && mkdir -p models/VibeVoice/base_model \
    && mkdir -p input/audio \
    && mkdir -p output/audio

# Modellek előre letöltése (opcionális, commenteld ki ha nem kell)
# RUN huggingface-cli download Cseti/VibeVoice_7B_Diffusion-head-LoRA_Hungarian-CV17 \
#     --local-dir /workspace/ComfyUI/models/VibeVoice/diffusion_head/hungarian

# RUN huggingface-cli download vibeai/vibevoice-7b-base-v1 \
#     --local-dir /workspace/ComfyUI/models/VibeVoice/base_model

# Start script másolása
COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh

# Port megnyitása
EXPOSE 8188 7860

# Munkakörnyezet visszaállítása
WORKDIR /workspace/ComfyUI

# Alapértelmezett parancs
CMD ["/workspace/start.sh"]
