import json
import sys
import uuid
import urllib.parse
import urllib.request

import websocket


# Usage:
#   python websocket_client.py workflow_api.json
#   python websocket_client.py workflow_api.json 127.0.0.1:8188
#
# Requires: pip install websocket-client


def queue_prompt(server, client_id, prompt):
    payload = {"prompt": prompt, "client_id": client_id}
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(f"http://{server}/prompt", data=data)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read())


def get_history(server, prompt_id):
    with urllib.request.urlopen(f"http://{server}/history/{prompt_id}") as response:
        return json.loads(response.read())


def get_image(server, image_info):
    query = urllib.parse.urlencode(
        {
            "filename": image_info["filename"],
            "subfolder": image_info["subfolder"],
            "type": image_info["type"],
        }
    )
    with urllib.request.urlopen(f"http://{server}/view?{query}") as response:
        return response.read()


def main():
    if len(sys.argv) < 2:
        print("Usage: python websocket_client.py <workflow_api.json> [server]", file=sys.stderr)
        raise SystemExit(1)

    workflow_path = sys.argv[1]
    server = sys.argv[2] if len(sys.argv) > 2 else "127.0.0.1:8188"
    client_id = str(uuid.uuid4())

    with open(workflow_path, "r", encoding="utf-8") as f:
        prompt = json.load(f)

    ws = websocket.WebSocket()
    ws.connect(f"ws://{server}/ws?clientId={client_id}")

    try:
        result = queue_prompt(server, client_id, prompt)
        prompt_id = result["prompt_id"]
        print(f"Queued prompt_id={prompt_id}")

        while True:
            msg = ws.recv()
            if isinstance(msg, str):
                data = json.loads(msg)
                if data.get("type") == "executing":
                    event = data.get("data", {})
                    if event.get("prompt_id") == prompt_id and event.get("node") is None:
                        break
            else:
                # Binary preview frame; ignore in this basic example.
                pass

        history = get_history(server, prompt_id)[prompt_id]
        output_count = 0
        for node_id, node_output in history.get("outputs", {}).items():
            for image_info in node_output.get("images", []):
                image_bytes = get_image(server, image_info)
                filename = image_info["filename"]
                with open(filename, "wb") as f:
                    f.write(image_bytes)
                output_count += 1
                print(f"Saved {filename} from node {node_id}")

        print(f"Done. Downloaded {output_count} image(s).")
    finally:
        ws.close()


if __name__ == "__main__":
    main()
