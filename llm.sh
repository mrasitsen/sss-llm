#!/bin/bash

# Define user configuration file location
CONFIG_DIR="$HOME/Library/Preferences"
CONFIG_FILE="$CONFIG_DIR/llm.config"

# Default model
DEFAULT_MODEL="ggml-org/Qwen2.5-Coder-1.5B-Instruct-Q8_0-GGUF"

# Function to create a configuration file if it doesn't exist
create_config_file() {
  if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
  fi

  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating configuration file: $CONFIG_FILE"
    # Set the default model when creating the config file
    echo "{\"model\": \"$DEFAULT_MODEL\"}" > "$CONFIG_FILE"
  fi
}

# Function to update the configuration file with the new model name
update_config_file() {
  local model_name=$1
  echo "Updating configuration file with model: $model_name"
  jq --arg model "$model_name" '.model = $model' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
}

# Function to get model from the configuration file
get_config_model() {
  model=$(jq -r '.model' "$CONFIG_FILE")
  if [ "$model" == "null" ]; then
    model=""
  fi
  echo "$model"
}

# Function to fetch model info from Hugging Face repository
fetch_model() {
  local model_name=$1
  echo "Fetching model $model_name from Hugging Face..."
  # Simulating model fetching; replace with actual model fetch logic
  if curl --silent --head --fail "https://huggingface.co/$model_name"; then
    echo "Model $model_name found."
    return 0
  else
    echo "Model $model_name not found."
    return 1
  fi
}

# Function to validate and parse the options
parse_options() {
  # Initialize the options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --model)
        shift
        if [[ -n "$1" && ! "$1" =~ ^- ]]; then
          MODEL="$1"
        else
          echo "Error: --model option requires a model name argument."
          exit 1
        fi
        ;;
      *)
        echo "Error: Unknown option '$1'."
        exit 1
        ;;
    esac
    shift
  done
}

# Function to print the command summary
print_help() {
  echo "Available Commands and Options:"
  echo "================================="
  echo "Commands:"
  echo "  up                        - Starts the llama cpp server"
  echo "  model                     - Gets the default model name"
  echo "  model='model_name'        - Sets the default model name"
  echo ""
  echo "Options for 'up':"
  echo "  --model model_name - Specifies the model to use"
  echo ""
  echo "Command format:"
  echo "  [command] [option1] [option2] ... [optionN]"
  echo "================================="
}

# Main function to handle the user commands
handle_command() {
  if [ "$COMMAND" == "up" ]; then
    # If a model is provided via options, use it, otherwise use the model from config
    if [ -n "$MODEL" ]; then
      fetch_model "$MODEL"
      if [ $? -eq 0 ]; then
        echo "Starting the llama cpp server with model $MODEL..."
        llama-server -hf "$MODEL" --port 8080 -ub 1024 -b 1024 -dt 0.1 --ctx-size 0 --cache-reuse 256
      else
        echo "Error: Model $MODEL could not be found. Server not started."
      fi
    else
      # Use the default model from config or fallback to hardcoded default
      MODEL=$(get_config_model)
      if [ -z "$MODEL" ]; then
        MODEL="$DEFAULT_MODEL"
      fi
      echo "Starting the llama cpp server with model $MODEL..."
      llama-server -hf "$MODEL" --port 8080 -ub 1024 -b 1024 -dt 0.1 --ctx-size 0 --cache-reuse 256
    fi
  elif [[ "$COMMAND" == model ]]; then
    echo "Current default model is: "
    get_config_model
  elif [[ "$COMMAND" == model=* ]]; then
    # Handle 'model="model_name"' input
    model_name=$(echo "$COMMAND" | sed 's/model=//')
    echo "Setting default model to $model_name"
    fetch_model "$model_name"
    if [ $? -eq 0 ]; then
      update_config_file "$model_name"
    else
      echo "Error: Model $MODEL could not be found. Server not started."
    fi
  else
    echo "Error: Invalid command. Please use a valid command."
    exit 1
  fi
}

# Main entry point
main() {
  # Initialize variables
  COMMAND=$1
  shift

  # If no command is provided, print the help
  if [ -z "$COMMAND" ]; then
    print_help
    exit 0
  fi

  # Create the config file if it doesn't exist
  create_config_file

  # Parse the options first to update any variables
  parse_options "$@"

  # Execute the command with the options
  handle_command
}

# Run the script
main "$@"