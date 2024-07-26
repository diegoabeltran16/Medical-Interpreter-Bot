#!/bin/bash

# Exit on any error
set -e
set -x  # Enable debugging output

# Set environment variables
export GITHUB_TOKEN=your_github_token
export GITHUB_REPO=github.com/diegoabeltran16/Medical-Interpreter-Bot.git

# Configure Git credential helper to store credentials temporarily 
git config --global credential.helper cache

# Print environment variables for debugging
echo "GITHUB_REPO: ${GITHUB_REPO}"

# Verify that environment variables are set
if [ -z "$GITHUB_REPO" ]; then
  echo "Error: GITHUB_REPO is not set"
  exit 1
fi

# Configure Git
git config --global user.email "diegobeltran1016@gmail.com"
git config --global user.name "Diego Alejandro Beltran"

# Remove remotes if they exist (to ensure clean state)
git remote remove github || true

# Add GitHub as a remote
git remote add github "https://${GITHUB_TOKEN}@${GITHUB_REPO}"
echo "GitHub remote added."

# Fetch all branches from GitHub
echo "Fetching branches from GitHub..."
git fetch github || echo "Failed to fetch from GitHub. Check the repository URL and token permissions."

# Checkout main branch
git checkout main

# Merge feature branches into main
for branch in $(git branch -r | grep 'github/feature/' | sed 's/github\///'); do
  echo "Merging ${branch} into main..."
  git merge "$branch" --no-ff -m "Merge ${branch} into main"
done

# Push the updated main branch to GitHub
echo "Pushing changes to GitHub..."
if git push github main; then
  echo "Pushed changes to GitHub successfully."
else
  echo "Failed to push changes to GitHub."
fi

echo "Feature branches merged and pushed to GitHub successfully."
