# ComfyUI Workflow

This repository contains a basic ComfyUI workflow for Stable Diffusion image generation.

## What is ComfyUI?

ComfyUI is a powerful and modular node-based GUI for Stable Diffusion. It allows you to design and execute advanced workflows using a graph/nodes interface.

## Workflow Description

The included `comfyui_workflow.json` file contains a basic text-to-image generation workflow with the following components:

### Nodes

1. **CheckpointLoaderSimple** - Loads the Stable Diffusion model checkpoint
   - Default: `sd_xl_base_1.0.safetensors` (SDXL base model)

2. **CLIPTextEncode (Positive)** - Encodes the positive prompt
   - Default prompt: "beautiful landscape, mountains, sunset, highly detailed, 8k"

3. **CLIPTextEncode (Negative)** - Encodes the negative prompt
   - Default prompt: "blurry, low quality, distorted, ugly"

4. **EmptyLatentImage** - Creates an empty latent image canvas
   - Resolution: 1024x1024 pixels
   - Batch size: 1

5. **KSampler** - Performs the diffusion sampling
   - Steps: 20
   - CFG Scale: 8
   - Sampler: euler
   - Scheduler: normal
   - Seed: randomize

6. **VAEDecode** - Decodes the latent image to pixel space

7. **SaveImage** - Saves the generated image
   - Filename prefix: "ComfyUI"

### Workflow Flow

```
CheckpointLoaderSimple ──┬──> CLIPTextEncode (Positive) ──┐
                         │                                 │
                         ├──> CLIPTextEncode (Negative) ──┤
                         │                                 ├──> KSampler ──> VAEDecode ──> SaveImage
                         └──────────────────────────────────┘
                                                           ↑
EmptyLatentImage ──────────────────────────────────────────┘
```

## How to Use

### Prerequisites

1. Install [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
2. Download a Stable Diffusion model (e.g., SDXL base model)
3. Place the model in the `ComfyUI/models/checkpoints/` directory

### Loading the Workflow

1. Start ComfyUI
2. In the ComfyUI interface, click "Load" button
3. Select the `comfyui_workflow.json` file from this repository
4. The workflow will appear in the node editor

### Customizing the Workflow

You can customize various parameters:

- **Prompts**: Edit the text in the CLIPTextEncode nodes to change what you want to generate
- **Image Size**: Modify the width and height in the EmptyLatentImage node
- **Quality Settings**: Adjust steps, CFG scale, and sampler in the KSampler node
- **Model**: Change the checkpoint file in the CheckpointLoaderSimple node

### Generating Images

1. After loading and customizing the workflow
2. Click "Queue Prompt" in ComfyUI
3. Wait for the generation to complete
4. The generated image will be saved in the `ComfyUI/output/` directory

## Workflow Features

- **Simple and beginner-friendly**: Easy to understand node structure
- **Customizable**: All parameters can be adjusted to your needs
- **SDXL compatible**: Configured for SDXL models by default
- **High quality**: Uses optimal settings for good results

## Troubleshooting

- **Model not found**: Make sure the checkpoint file name matches the one in your ComfyUI models folder
- **Out of memory**: Try reducing the image resolution or batch size
- **Slow generation**: Reduce the number of steps or image resolution

## License

This workflow is free to use and modify for any purpose.
