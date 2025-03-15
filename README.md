SSS LLM (Super Simple Stupid LLM)

SSS LLM is a simple command-line tool for running and managing large language models. It allows you to easily specify and start a language model server with minimal setup.
Installation

    Clone the repository and navigate to the project folder:

git clone https://your-repository-url/SSS-LLM.git
cd SSS-LLM

Make build.sh executable:

chmod +x build.sh

Run the build.sh script to copy llm.sh to /usr/local/bin:

    ./build.sh

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