#!/usr/bin/env python3
"""Download all 3 Laya model checkpoints directly from official Hugging Face Hub."""
import os
import sys

# Fix Python urllib/requests IPv6 ::1 issue with NO_PROXY
os.environ["NO_PROXY"] = "localhost,127.0.0.1"
os.environ["no_proxy"] = "localhost,127.0.0.1"

from huggingface_hub import snapshot_download

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODELS_DIR = os.path.join(BASE_DIR, "models")

MODELS = {
    "multilingual": "convaiinnovations/laya-multilingual",
    "english": "convaiinnovations/laya",
    "typed-decisions": "convaiinnovations/laya-typed-decisions",
}

ALLOW_PATTERNS = [
    "rl_agent_config.json",
    "model.safetensors",
    "tokenizer/*",
    "encoder/*",
]


def download_model(name: str, repo_id: str):
    target_dir = os.path.join(MODELS_DIR, name)
    print(f"\n========================================================")
    print(f"[*] Downloading {name} from {repo_id}...")
    print(f"[*] Target directory: {target_dir}")
    print(f"========================================================")

    os.makedirs(target_dir, exist_ok=True)
    snapshot_download(
        repo_id=repo_id,
        local_dir=target_dir,
        allow_patterns=ALLOW_PATTERNS,
        local_dir_use_symlinks=False,
    )
    print(f"[✓] {name} downloaded successfully!")


def main():
    print(f"Starting download of all 3 models to: {MODELS_DIR}")
    for name, repo_id in MODELS.items():
        try:
            download_model(name, repo_id)
        except Exception as e:
            print(f"[✗] Failed to download {name}: {e}", file=sys.stderr)
            sys.exit(1)
    print("\n[🎉] All models downloaded successfully into ./models directory!")


if __name__ == "__main__":
    main()
