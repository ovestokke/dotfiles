---
name: comfyui-programmatic
description: Build, automate, and debug ComfyUI workflows from code. Use when the user asks about the ComfyUI API, workflow JSON, queueing prompts, WebSocket execution monitoring, downloading outputs, integrating ComfyUI with Python or Node.js, or turning a ComfyUI graph into an automated service/script. Also use when the user wants to export a workflow from the UI and run it headlessly.
---

# ComfyUI Programmatic Skill

Use this skill to help users drive ComfyUI as a graph execution server instead of only as a GUI app.

## Core Mental Model

ComfyUI's API does **not** take a plain text prompt by itself. It takes a **workflow graph encoded as JSON**.

- Each top-level key is a node ID string like `"3"` or `"save_image_websocket_node"`
- Each node has a `class_type`
- Each node has `inputs`
- Input values are either:
  - literals like numbers / strings / booleans
  - connections like `["4", 0]`, meaning "use output index 0 from node 4"

When helping a user automate ComfyUI, prefer this workflow:

1. Build the workflow in the ComfyUI UI first
2. Export it with **File -> Export (API)**
3. Load the exported JSON in code
4. Modify only the inputs the user cares about
5. Submit the graph to the API
6. Wait for completion through WebSocket or poll history
7. Fetch outputs from history or stream them directly

This is much safer than inventing large graphs from scratch.

## Default Workflow

When the user asks to use ComfyUI programmatically:

1. Confirm the ComfyUI server address, defaulting to `127.0.0.1:8188`
2. Ask whether they already have an exported API workflow JSON
3. If not, instruct them to export one from the UI
4. Determine whether they want:
   - a one-off script
   - a reusable Python helper
   - a Node.js integration
   - a long-running service
5. Prefer Python examples unless the user asks for Node.js
6. Choose an output strategy:
   - `SaveImage` + `/history` + `/view` for simple reliable automation
   - `SaveImageWebsocket` for direct streaming without disk roundtrips

## Required Endpoints

The most important endpoints are:

- `POST /prompt` — validate and queue a workflow
- `GET /ws?clientId=...` — receive execution events over WebSocket
- `GET /history/{prompt_id}` — inspect outputs for a finished run
- `GET /view?...` — download an output image by filename/subfolder/type
- `GET /object_info` — inspect available node schemas
- `GET /queue` — inspect running and pending jobs
- `POST /interrupt` — stop current execution

If you need exact payload shapes or field meanings, read:
- `references/api-endpoints.md`
- `references/workflow-json.md`
- `references/patterns.md`

## Recommended Implementation Pattern

### Pattern A: Queue -> wait on WebSocket -> fetch from history

Use this as the default.

Why this pattern is good:
- simple
- robust
- works with normal `SaveImage` nodes
- easy to debug because outputs are visible in ComfyUI history

Implementation outline:

1. Open WebSocket with a `clientId`
2. `POST /prompt` with `prompt` and the same `client_id`
3. Capture returned `prompt_id`
4. Wait for an `executing` event where:
   - `data.prompt_id` matches your prompt
   - `data.node` is `null`
5. Call `/history/{prompt_id}`
6. Download images using `/view`

### Pattern B: Queue -> receive images directly with `SaveImageWebsocket`

Use this when the user wants raw images in-memory for an app or API.

Why this pattern is good:
- avoids saving final images to disk first
- useful for web backends, bots, and live tools

Caution:
- still expect binary preview frames over the socket
- only treat binary messages as final outputs when the active node is the `SaveImageWebsocket` node

## How to Modify a Workflow Safely

Prefer **small targeted edits** to exported graphs.

Common safe changes:
- positive prompt text in `CLIPTextEncode`
- negative prompt text
- `seed`
- `steps`
- `cfg`
- width / height on latent image nodes
- checkpoint names
- filename prefixes

Avoid casually changing:
- graph topology
- node IDs without updating references
- class names unless you know the node exists on that server
- model names that may not be installed

When editing a workflow for the user:

1. Find the relevant node by `class_type`
2. Verify the input field exists
3. Change only that field
4. Preserve the rest of the graph exactly

## What to Do When the User Has No Workflow Yet

If the user says something like "generate an image with ComfyUI from Python" and has no exported workflow yet:

1. Explain that ComfyUI is graph-based
2. Offer a minimal example using a standard default workflow
3. Clearly mark that the node IDs and model names may need adaptation
4. Recommend exporting the exact workflow from their UI once they have something working

## Node Discovery and Schema Inspection

If you need to construct or validate workflows dynamically, inspect:

- `GET /object_info`
- `GET /object_info/{node_class}`

Use this when:
- the user asks what inputs a node supports
- you need to confirm whether a custom node exists
- you need to generate code that adapts to installed nodes

## Common Failure Modes

### Invalid prompt / node errors

If `POST /prompt` returns HTTP 400 with `node_errors`:
- the graph is invalid
- a required input is missing
- a node type is unavailable
- an input type does not match what the node expects

### Workflow refers to missing models

Common issue:
- checkpoint, LoRA, VAE, or other model filenames are not present on the target ComfyUI instance

Help the user by checking exact model names in the exported graph.

### WebSocket completion never arrives

Check:
- same `client_id` used in both WebSocket and prompt submission
- prompt actually queued successfully
- workflow is not stuck on a broken node
- code is handling JSON text frames and ignoring binary preview frames appropriately

### Results not found in history

Check:
- the workflow actually contains output nodes like `SaveImage`
- you are using the returned `prompt_id`
- execution finished before fetching history

## Output Expectations

When answering the user, usually provide:

1. A short explanation of the graph-based API model
2. A minimal working code example
3. The exact endpoints involved
4. A note about exporting workflow JSON from the UI
5. Any assumptions, especially node IDs and model names

Prefer code that is ready to run with small edits rather than abstract pseudo-code.

## Python First

Default to Python unless the user asks for something else.

If you need ready-made starting points, use the bundled scripts:
- `scripts/queue_prompt.py`
- `scripts/websocket_client.py`

If the user asks for Node.js, adapt the same flow using:
- HTTP `POST /prompt`
- a WebSocket client to `/ws`
- optional image download from `/view`

## Minimal Example Shape

A minimal helpful example usually includes:

```python
import json, uuid, urllib.request, urllib.parse
import websocket

server = "127.0.0.1:8188"
client_id = str(uuid.uuid4())
```

Then:
- load workflow JSON
- patch a few inputs
- queue prompt
- wait for completion
- fetch history
- download outputs

## When to Read the Reference Files

Read these as needed:

- `references/api-endpoints.md` when you need exact endpoint behavior
- `references/workflow-json.md` when you need to explain graph structure or node links
- `references/patterns.md` when you need implementation recipes or troubleshooting patterns

Do not dump all reference content to the user unless they ask. Read only what is needed and give a focused answer.
