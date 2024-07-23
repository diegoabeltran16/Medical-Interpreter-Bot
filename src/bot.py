import os
import discord
from dotenv import load_dotenv
from openai import OpenAI

# Load environment variables from .env file
load_dotenv()

DISCORD_TOKEN = os.getenv('DISCORD_TOKEN')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

# Set up OpenAI API key
client = OpenAI(api_key=OPENAI_API_KEY)

# Create a new client instance
intents = discord.Intents.default()
discord_client = discord.Client(intents=intents)

# Event that triggers when the bot is ready
@discord_client.event
async def on_ready():
    print(f'We have logged in as {discord_client.user}')

# Event that triggers when a message is sent in a channel the bot has access to
@discord_client.event
async def on_message(message):
    # Prevent the bot from responding to its own messages
    if message.author == discord_client.user:
        return

    # Respond to a specific command using ChatGPT
    if message.content.startswith('$ask'):
        query = message.content[len('$ask '):]
        try:
            completion = client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {
                        "role": "user",
                        "content": query
                    }
                ],
                temperature=0.7
            )
            answer = completion.choices[0].message['content']
            await message.channel.send(answer)
        except Exception as e:
            await message.channel.send(f"An error occurred: {str(e)}")

# Run the bot with the specified token
discord_client.run(DISCORD_TOKEN)
