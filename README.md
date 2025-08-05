# Better ComfyUI Slim - August 2025 Version

This is a fork of kodxana's original Dockerfiles for a slim ComfyUI build. I was having various issues getting it to run in August 2025, so this version is updated with a working dependency list as of 8/5/2025, and lots of debugging info in the console logs if you run into any issues.

The original version had a 5090 version - I do not. I have no use for those. 



A compact and optimized Docker container designed as an easy-to-use RunPod template for ComfyUI. Images are highly optimized for size, only ~650MB while including all features!

## Quick Deploy on RunPod

[![Deploy Regular on RunPod](https://img.shields.io/badge/Deploy%20on%20RunPod-Regular%20(CUDA%2012.4)-4B6BDC?style=for-the-badge&logo=docker)](https://runpod.io/console/deploy?template=s5ap6pd6xg)


Choose your template:
- 🖥️ [Regular Template](https://runpod.io/console/deploy?template=s5ap6pd6xg) - For most GPUs (CUDA 12.4)


## Why Better ComfyUI Slim?

- 🎯 Purpose-built for RunPod deployments
- 📦 Ultra-compact: Only ~650MB image size (compared to multi-GB alternatives)
- 🚀 Zero configuration needed: Works out of the box
- 🛠️ Includes all essential tools for remote work

## Features

- 🚀 Two optimized variants:
  - Regular: CUDA 12.4 with stable PyTorch
  - RTX 5090: CUDA 12.8 with PyTorch Nightly (optimized for latest NVIDIA GPUs)
- 🔧 Built-in tools:
  - SSH access
- 🎨 Pre-installed custom nodes:
  - ComfyUI-Manager
  - ComfyUI-Crystools
  - ComfyUI-KJNodes
- ⚡ Performance optimizations:
  - UV package installer for faster dependency installation
  - NVENC support in FFmpeg
  - Optimized CUDA configurations

## Ports

- `8187`: ComfyUI web interface
- `22`: SSH access

## Custom Arguments

You can customize ComfyUI startup arguments by editing `/workspace/madapps/comfyui_args.txt`. Add one argument per line:
```
--max-batch-size 8
--preview-method auto
```

## Directory Structure

- `/workspace/madapps/ComfyUI`: Main ComfyUI installation
- `/workspace/madapps/comfyui_args.txt`: Custom arguments file

## License

This project is licensed under the GPLv3 License.
