#!/bin/bash
set -ex

echo "##########################################"
echo "### STEP 1/4: System Initialization    ###"
echo "##########################################"

COMFYUI_DIR="/workspace/madapps/ComfyUI"
VENV_DIR="$COMFYUI_DIR/.venv"
PIP_EXECUTABLE="$VENV_DIR/bin/pip"
PYTHON_EXECUTABLE="$VENV_DIR/bin/python"

# Setup ComfyUI if needed
if [ ! -f "$PIP_EXECUTABLE" ]; then
    echo "First-time setup: ComfyUI or virtual environment not found."
    echo "Cloning ComfyUI repository..."
    if [ ! -d "$COMFYUI_DIR" ]; then
        cd /workspace/madapps
        git clone https://github.com/comfyanonymous/ComfyUI.git
    fi
    
    echo "Creating Python virtual environment..."
    cd $COMFYUI_DIR
    rm -rf $VENV_DIR
    virtualenv $VENV_DIR
    
    echo "##########################################"
    echo "### STEP 2/4: Dependency Installation  ###"
    echo "##########################################"
    echo "Installing main dependencies (this may take a while)..."
    $PIP_EXECUTABLE install /wheels/*.whl
    
    sed -i 's/^torch/#torch/' requirements.txt
    sed -i 's/^torchvision/#torchvision/' requirements.txt
    sed -i 's/^torchaudio/#torchaudio/' requirements.txt
    
    $PIP_EXECUTABLE install -r requirements.txt
else
    echo "ComfyUI and virtual environment found. Skipping initial setup."
    echo "##########################################"
    echo "### STEP 2/4: Dependency Installation  ###"
    echo "##########################################"
fi

# Ensure critical packages are installed
echo "Verifying critical packages..."
$PIP_EXECUTABLE install PyYAML torchsde

# Install dependencies for custom nodes
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
if [ -d "$CUSTOM_NODES_DIR" ]; then
    echo "Checking for custom node dependencies..."
    for req_file in $(find "$CUSTOM_NODES_DIR" -name "requirements.txt"); do
        if [ -f "$req_file" ]; then
            echo "Installing dependencies from $req_file..."
            $PIP_EXECUTABLE install -r "$req_file"
        fi
    done
fi

echo "##########################################"
echo "### STEP 3/4: Launching Services       ###"
echo "##########################################"

# Start supporting services
echo "Starting SSH daemon..."
/usr/sbin/sshd


echo "##########################################"
echo "### STEP 4/4: Starting ComfyUI         ###"
echo "##########################################"

# Start ComfyUI as the main foreground process
cd $COMFYUI_DIR
if ! $PYTHON_EXECUTABLE main.py --listen 0.0.0.0 --port 8188; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!! ComfyUI FAILED TO START. See error above.  !!"
    echo "!! The container will exit in 60 seconds.     !!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    sleep 60
    exit 1
fi
