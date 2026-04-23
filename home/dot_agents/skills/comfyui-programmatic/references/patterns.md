# ComfyUI Programmatic Patterns

## Pattern 1: Simple Python Script

Use when the user wants a minimal one-off automation script.

Flow:
1. load exported API workflow JSON
2. patch prompt/seed/size
3. `POST /prompt`
4. wait for completion over `/ws`
5. read `/history/{prompt_id}`
6. download images from `/view`

## Pattern 2: Direct Streaming

Use when the user wants images in memory.

Flow:
1. replace `SaveImage` with `SaveImageWebsocket`
2. open `/ws`
3. queue prompt with same `client_id`
4. track current node from `executing` events
5. collect binary frames only while the current node is the websocket image node

## Pattern 3: Service Wrapper

Use when the user wants to expose ComfyUI behind their own API.

Recommended wrapper responsibilities:
- maintain server address config
- store or load workflow templates
- patch input values only
- queue jobs
- map `prompt_id` to application job IDs
- surface cancellation via `/interrupt`
- fetch outputs and return normalized URLs or bytes

## Pattern 4: Dynamic Node Inspection

Use when the user's environment varies or custom nodes may be present.

Flow:
1. call `/object_info`
2. verify needed node classes exist
3. adapt code or fail clearly

## Troubleshooting Checklist

### Queueing fails
- check ComfyUI is running
- check server address and port
- inspect HTTP 400 response body
- inspect `node_errors`

### Execution never finishes
- verify workflow works in the UI first
- verify matching `client_id`
- ignore preview binary frames unless intentionally decoding them
- check for missing models or broken custom nodes

### No image outputs
- verify the graph contains an output node
- verify you fetched history for the correct `prompt_id`
- check whether output is under `images` or another key

### Workflow portability issues
- exported graphs are only as portable as the target ComfyUI install
- checkpoints, LoRAs, VAEs, and custom nodes must exist on the target machine
- when sharing code, mention required models and custom node dependencies

## Default Advice to Give Users

If the user is just getting started, tell them:
- ComfyUI is graph-based, not prompt-only
- export a working workflow from the UI first
- patch a few known inputs instead of rewriting the graph
- start with Python and `SaveImage`
- add WebSocket streaming only when they need live or in-memory outputs
