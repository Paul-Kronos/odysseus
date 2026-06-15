MODEL_NAME="llama3.2"
AGENT_NAME="Odysseus"

API_URL="http://localhost:11434"
LOG_DIR="./logs"

check_ollama() {
  if ! command -v ollama &> /dev/null; then
    echo "Error: Ollama is not installed."
    exit 1
  fi
  if ! curl -s http://localhost:11434 > /dev/null 2>&1; then
    echo "Warning: Ollama might not be running."
  fi
}
