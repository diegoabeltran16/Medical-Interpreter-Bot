#!/bin/bash

# Exit on any error
set -e
set -x  # Enable debugging output

branch=$1

if [ -z "$branch" ]; then
  echo "Error: Branch name is not provided"
  exit 1
fi

# Checkout the branch
echo "Checking out branch $branch..."
git checkout -b $branch main || git checkout $branch

# Merge changes from GitHub to GitLab
echo "Merging changes from GitHub to GitLab for branch $branch..."
if git pull github "$branch"; then
  echo "Pulled changes from GitHub for branch $branch successfully."
else
  echo "Failed to pull changes from GitHub for branch $branch."
fi
if git push gitlab "$branch"; then
  echo "Pushed changes to GitLab for branch $branch successfully."
else
  echo "Failed to push changes to GitLab for branch $branch."
fi

# Merge changes from GitLab to GitHub
echo "Merging changes from GitLab to GitHub for branch $branch..."
if git pull gitlab "$branch"; then
  echo "Pulled changes from GitLab for branch $branch successfully."
else
  echo "Failed to pull changes from GitLab for branch $branch."
fi
if git push github "$branch"; then
  echo "Pushed changes to GitHub for branch $branch successfully."
else
  echo "Failed to push changes to GitHub for branch $branch."
fi

# Handle conflicts if any
echo "Handling conflicts for branch $branch (if any)..."
if git merge --strategy-option theirs; then
  echo "Merged conflicts for branch $branch using 'theirs' strategy."
else
  echo "No conflicts to merge for branch $branch or merge failed."
fi
if git push github "$branch"; then
  echo "Final push to GitHub for branch $branch successful."
else
  echo "Final push to GitHub for branch $branch failed."
fi
if git push gitlab "$branch"; then
  echo "Final push to GitLab for branch $branch successful."
else
  echo "Final push to GitLab for branch $branch failed."
fi
