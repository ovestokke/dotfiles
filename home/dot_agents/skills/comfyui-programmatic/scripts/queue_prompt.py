import json
import sys
import urllib.request


# Usage:
#   python queue_prompt.py workflow_api.json
#   python queue_prompt.py workflow_api.json 127.0.0.1:8188
#
# This script queues a workflow and prints the JSON response.


def main():
    if len(sys.argv) < 2:
        print("Usage: python queue_prompt.py <workflow_api.json> [server]", file=sys.stderr)
        raise SystemExit(1)

    workflow_path = sys.argv[1]
    server = sys.argv[2] if len(sys.argv) > 2 else "127.0.0.1:8188"

    with open(workflow_path, "r", encoding="utf-8") as f:
        prompt = json.load(f)

    payload = {"prompt": prompt}
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(f"http://{server}/prompt", data=data)

    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read())

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
