# ComfyUI API Endpoints

These are the endpoints most useful for programmatic control.

## POST /prompt

Queue a workflow for execution.

Request body shape:

```json
{
  "prompt": {"3": {"class_type": "KSampler", "inputs": {}}},
  "client_id": "optional-websocket-client-id",
  "prompt_id": "optional-custom-id",
  "extra_data": {},
  "number": 1,
  "front": false,
  "partial_execution_targets": []
}
```

Important fields:
- `prompt`: workflow graph JSON
- `client_id`: ties prompt events to a WebSocket session
- `prompt_id`: optional custom identifier
- `extra_data`: extra execution data; if API nodes are used, credentials may go here

Typical successful response:

```json
{
  "prompt_id": "uuid",
  "number": 42,
  "node_errors": {}
}
```

Typical failure:
- HTTP 400 with `error` and `node_errors`

## GET /ws?clientId=...

Open a WebSocket to receive execution events.

Typical text events include:
- `status`
- `executing`
- `executed`
- `execution_start`
- `execution_success`

A common completion check is:
- message type is `executing`
- `data.prompt_id` matches your run
- `data.node == null`

Binary frames may contain preview image data.

## GET /history/{prompt_id}

Get outputs and metadata for one finished prompt.

Useful path:

```json
history[prompt_id]["outputs"]
```

Image outputs usually appear like:

```json
{
  "images": [
    {
      "filename": "ComfyUI_00001_.png",
      "subfolder": "",
      "type": "output"
    }
  ]
}
```

## GET /view

Download a file returned by history.

Query parameters:
- `filename`
- `subfolder`
- `type`

Example:

```text
/view?filename=ComfyUI_00001_.png&subfolder=&type=output
```

Returns raw bytes.

## GET /object_info

Return node metadata for all node classes available on this server.

Use this to inspect available built-in and custom nodes.

## GET /object_info/{node_class}

Return node metadata for one node class.

Useful when dynamically generating or validating workflows.

## GET /queue

Return queued and running prompt information.

Useful for dashboards, orchestration, and debugging stuck jobs.

## GET /history

Return recent prompt history. Supports browsing more than one prompt.

## GET /api/jobs and GET /api/jobs/{job_id}

Job-oriented views over running, queued, and finished work.

Use when building a management layer or status UI.

## POST /interrupt

Interrupt current execution.

Useful when the user wants cancellation from code.
