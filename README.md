# Better ComfyUI Slim - August 2025 Version + Instructions for Newbies

This is a fork of kodxana's original Dockerfiles for a slim ComfyUI build. I was having various issues getting it to run in August 2025, so this version is hardcoded with a working dependency list as of 8/5/2025, and lots of debugging info in the console logs if you run into any issues.

The original version had a 5090 version - I do not. I have no use for those. The original version also had a File Browser and Zasper, those have also been left out.

After ComfyUI boots up, RunPod still needs a few minutes for ComfyUI. If you see the message "Using pytorch attention" - just wait about 2 minutes. The final message you will get from the Container Log confirming it's ready is this: "To see the GUI go to: http://0.0.0.0:8188"

I had a lot of questions about downloading and storing models. Originally I was trying to use Cloudflare R2 as storage, but ultimately I could not figure it out. Doing the storage via RunPod makes things a lot easier. Start by making a Network Volume with about 150 GB. You will need to know which sort of GPU you are planning on using because each storage location has certain machines available to it with the storage. In my case I wanted to use A100s, so I chose the Kansas location as that's where the most machines were. 

From now on, any time you start anything on RunPod, start by going to your storage, clicking your new Network Volume, and then clicking Deploy Pod With Volume. The first time you connect with the network volume, it will kick off an install script that might take 30 minutes or so. This is installing ComfyUI to your network volume. As far as downloading the models/safetensors/checkpoints - cURLing via the Web SSH is by far the easiest and most effective method. The easiest way is to just launch ComfyUI, click



## Quick Deploy on RunPod

[![Deploy Regular on RunPod](https://img.shields.io/badge/Deploy%20on%20RunPod-Regular%20(CUDA%2012.4)-4B6BDC?style=for-the-badge&logo=docker)](https://runpod.io/console/deploy?template=s5ap6pd6xg)

## Ports

- `8188`: ComfyUI web interface
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
