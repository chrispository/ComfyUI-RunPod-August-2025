#!/bin/bash
set -ex

COMFYUI_DIR="/workspace/madapps/ComfyUI"
VENV_DIR="$COMFYUI_DIR/.venv"
PIP_EXECUTABLE="$VENV_DIR/bin/pip"
PYTHON_EXECUTABLE="$VENV_DIR/bin/python"
FILEBROWSER_CONFIG="/workspace/madapps/.filebrowser.json"

# Setup ComfyUI if needed
if [ ! -f "$PIP_EXECUTABLE" ]; then
    echo "First time setup or corrupted venv: Installing ComfyUI and dependencies..."
    
    # Clone ComfyUI if not present
    if [ ! -d "$COMFYUI_DIR" ]; then
        cd /workspace/madapps
        git clone https://github.com/comfyanonymous/ComfyUI.git
    fi
    
    # Create and setup virtual environment
    cd $COMFYUI_DIR
    # Remove potentially corrupted venv
    rm -rf $VENV_DIR
    virtualenv $VENV_DIR
    
    # Install dependencies
    $PIP_EXECUTABLE install /wheels/*.whl
    
    # Comment out torch packages from requirements.txt
    sed -i 's/^torch/#torch/' requirements.txt
    sed -i 's/^torchvision/#torchvision/' requirements.txt
    sed -i 's/^torchaudio/#torchaudio/' requirements.txt
    
    $PIP_EXECUTABLE install -r requirements.txt
fi

# Ensure critical packages are installed
echo "Ensuring critical packages are installed..."
$PIP_EXECUTABLE install PyYAML
echo "Listing packages before torchsde install:"
$PIP_EXECUTABLE list
echo "Attempting to install torchsde..."
$PIP_EXECUTABLE install torchsde
echo "Listing packages after torchsde install:"
$PIP_EXECUTABLE list
echo "Verifying torchsde installation..."
$PYTHON_EXECUTABLE -c "import torchsde; print('torchsde successfully imported')"

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

# Start supporting services
echo "Starting SSH daemon..."
/usr/sbin/sshd

# Configure and Start FileBrowser
if [ ! -f "$FILEBROWSER_CONFIG" ]; then
    echo "Creating default File Browser config..."
    cat <<EOF > "$FILEBROWSER_CONFIG"
{
  "port": 8080,
  "address": "0.0.0.0",
  "root": "/workspace/madapps",
  "database": "/workspace/madapps/.filebrowser.db",
  "log": "stdout",
  "username": "admin",
  "password": "password"
}
EOF
fi

echo "Starting File Browser in the background..."
filebrowser -c "$FILEBROWSER_CONFIG" &

# Start ComfyUI as the main foreground process
echo "Starting ComfyUI..."
cd $COMFYUI_DIR
if ! $PYTHON_EXECUTABLE main.py --listen 0.0.0.0 --port 8187; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!! ComfyUI FAILED TO START. See error above.  !!"
    echo "!! The container will exit in 60 seconds.     !!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    sleep 60
    exit 1
fi
