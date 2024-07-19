import os
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Create the OpenAI client instance
client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
)

# Use the new client instance to create a chat completion
completion = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "user",
            "content": "Say this is a test"
        }
    ],
    temperature=0.7
)

print(completion.choices[0].message['content'])
