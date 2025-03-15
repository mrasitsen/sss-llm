# SSS LLM (Super Simple Stupid LLM)

SSS LLM is a simple command-line tool for running and managing large language models with llama-cpp. It allows you to easily specify and start a language model server with minimal setup. It is super simple and stupid. It aims to be like that. 

## Installation

Clone the repository and navigate to the project folder:

    git clone https://github.com/mrasitsen/sss-llm
    cd sss-llm

Run the build.sh script to copy llm.sh to /usr/local/bin:

    sudo bash build.sh

## Usage

Start the server with the default model:

    llm up

Start the server with a custom model:

    llm up --model "huggingface-model-name"

Get-Set a new default model:

    llm model                           // GET
    llm model="new-default-model"       // SET    

## Configuration

The default model is stored in ~/Library/Preferences/llm.config. You can change the default model using:

    llm model="new-default-model"

## License

MIT License