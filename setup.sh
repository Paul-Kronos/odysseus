#!/bin/bash

echo "==============================="
echo "   Odysseus Setup"
echo "==============================="

# Check Git Bash / bash environment
if [ -z "$BASH_VERSION" ]; then
  echo "Error: Please run this in Git Bash."
  exit 1
fi

# Check Ollama
if ! command -v ollama &> /dev/null; then
  echo "Error: Ollama is not installed."
  echo "Download it from: https://ollama.com"
  exit 1
fi

# Make all scripts executable
chmod +x odysseus.sh hermes.sh athena.sh

# Pull the model if not already present
echo "Checking for llama3.2 model..."
ollama pull llama3.2

# Create required folders and files
mkdir -p logs
touch memory.txt

echo ""
echo "Setup complete. Run ./odysseus.sh --menu to start."
