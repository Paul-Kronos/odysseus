# Odysseus — Personal AI CLI

A local AI assistant running on Git Bash (Windows) via Ollama.

## Requirements
- Windows with Git Bash
- Ollama installed (https://ollama.com)
- llama3.2 model pulled via Ollama

## Setup
Run: bash setup.sh

## Usage
./odysseus.sh --menu
./odysseus.sh --chat
./odysseus.sh --file <filename>
./odysseus.sh --batch <filename>
./odysseus.sh --inject <prompt>
./odysseus.sh --model <modelname>

## Chat Commands
/hermes <question>  - Fast, concise answer
/athena <question>  - Deep, analytical answer
/remember <note>    - Save to long-term memory
/bye                - End session

## Files
odysseus.sh  - Main script
config.sh    - Model and agent settings
hermes.sh    - Hermes agent
athena.sh    - Athena agent
memory.txt   - Long-term memory store
logs/        - Chat logs
setup.sh     - First-time setup