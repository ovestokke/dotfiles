# ComfyUI Workflow JSON

ComfyUI executes a directed graph encoded as JSON.

## Basic Structure

```json
{
  "3": {
    "class_type": "KSampler",
    "inputs": {
      "seed": 5,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "normal",
      "model": ["4", 0],
      "positive": ["6", 0],
      "negative": ["7", 0],
      "latent_image": ["5", 0]
    }
  }
}
```

## Rules

- top-level keys are node IDs, usually strings
- each node contains `class_type`
- each node contains `inputs`
- an input can be:
  - a literal value such as `512`, `"text"`, or `true`
  - a graph connection such as `["4", 0]`

## Connection Semantics

```json
"positive": ["6", 0]
```

This means:
- for input `positive`
- use output index `0`
- from node `"6"`

## Best Practice: Export From UI

Prefer exporting a real working workflow from ComfyUI with **File -> Export (API)**.

Why:
- node IDs already line up
- installed custom nodes are represented correctly
- graph structure is known valid
- code can patch only the user-controlled values

## Safe Edits

Good fields to patch in code:
- text prompt values in `CLIPTextEncode`
- `seed`
- `steps`
- `cfg`
- width / height on latent nodes
- output filename prefixes
- checkpoint names when the target server has that checkpoint

## Risky Edits

Be careful with:
- changing node IDs
- changing connection arrays
- swapping node classes without verifying required inputs
- deleting nodes still referenced elsewhere
- assuming a custom node exists on another machine

## Finding Relevant Nodes

When patching a workflow programmatically, search by:
- `class_type`
- unique input names
- obvious output nodes such as `SaveImage`

Prefer finding nodes semantically instead of hard-coding IDs when possible.

## SaveImage vs SaveImageWebsocket

### SaveImage

- saves files in ComfyUI output storage
- results appear in `/history/{prompt_id}`
- download via `/view`
- simplest default for scripts

### SaveImageWebsocket

- streams image bytes over the WebSocket
- avoids saving final images first
- useful for apps that want in-memory results
- requires careful handling of binary frames
