#!/bin/bash
set -ex

COMFYUI_DIR="/workspace/madapps/ComfyUI"
VENV_DIR="$COMFYUI_DIR/.venv"

# Setup ComfyUI if needed
if [ ! -d "$COMFYUI_DIR" ] || [ ! -d "$VENV_DIR" ]; then
    echo "First time setup: Installing ComfyUI and dependencies..."
    
    # Clone ComfyUI if not present
    if [ ! -d "$COMFYUI_DIR" ]; then
        cd /workspace/madapps
        git clone https://github.com/comfyanonymous/ComfyUI.git
    fi
    
    # Create and setup virtual environment if not present
    if [ ! -d "$VENV_DIR" ]; then
        cd $COMFYUI_DIR
        virtualenv $VENV_DIR
        
        # Install the requirements one by one
        $VENV_DIR/bin/pip install /wheels/*.whl
        
        # Comment out torch packages from requirements.txt
        sed -i 's/^torch/#torch/' requirements.txt
        sed -i 's/^torchvision/#torchvision/' requirements.txt
        sed -i 's/^torchaudio/#torchaudio/' requirements.txt
        
        $VENV_DIR/bin/pip install -r requirements.txt
    fi
fi

# Start ComfyUI
cd $COMFYUI_DIR
$VENV_DIR/bin/python main.py --listen 0.0.0.0 --port 8188
