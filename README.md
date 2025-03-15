SSS LLM (Super Simple Stupid LLM)

SSS LLM is a simple command-line tool for running and managing large language models with llama-cpp. It allows you to easily specify and start a language model server with minimal setup. It is super simple and stupid. It aims to be like that. 

Installation

Clone the repository and navigate to the project folder:

    git clone https://your-repository-url/sss-llm.git
    cd sss-llm

Run the build.sh script to copy llm.sh to /usr/local/bin:

    sudo bash build.sh

Usage

Start the server with the default model:

    llm up

Start the server with a custom model:

    llm up --model "huggingface-model-name"

Set a new default model:

    llm model="new-default-model"

Configuration

The default model is stored in ~/Library/Preferences/llm.config. You can change the default model using:

    llm model="new-default-model"

License

MIT License