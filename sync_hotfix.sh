#!/bin/bash

# Exit on any error
set -e
set -x  # Enable debugging output

# Define hotfix branches to sync
hotfix_branches=("hotfix/critical-fix")

for branch in "${hotfix_branches[@]}"; do
  ./sync_branch.sh "$branch" || { echo "Failed to sync hotfix branch $branch"; exit 1; }
done

echo "Hotfix branches sync process completed."
