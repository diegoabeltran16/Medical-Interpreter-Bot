import os
import discord
from dotenv import load_dotenv
import openai

# Load environment variables from .env file
load_dotenv()
DISCORD_TOKEN = os.getenv('DISCORD_TOKEN')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

# Debugging: Print environment variables to ensure they are loaded correctly
print("DISCORD_TOKEN:", DISCORD_TOKEN)
print("OPENAI_API_KEY:", OPENAI_API_KEY)

# Set up OpenAI API key
openai.api_key = OPENAI_API_KEY

# Create a new client instance
intents = discord.Intents.default()
client = discord.Client(intents=intents)

# Event that triggers when the bot is ready
@client.event
async def on_ready():
    print(f'We have logged in as {client.user}')

# Event that triggers when a message is sent in a channel the bot has access to
@client.event
async def on_message(message):
    # Prevent the bot from responding to its own messages
    if message.author == client.user:
        return

    # Respond to a specific command using ChatGPT
    if message.content.startswith('$ask'):
        query = message.content[len('$ask '):]
        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": query}
                ]
            )
            answer = response['choices'][0]['message']['content']
            await message.channel.send(answer)
        except Exception as e:
            await message.channel.send(f"An error occurred: {str(e)}")

# Run the bot with the specified token
client.run(DISCORD_TOKEN)
