#!/bin/bash

# Exit on any error
set -e
set -x  # Enable debugging output

# Define feature branches to sync
feature_branches=("feature/initial-setup" "feature/another-feature")

for branch in "${feature_branches[@]}"; do
  ./sync_branch.sh "$branch" || { echo "Failed to sync feature branch $branch"; exit 1; }
done

echo "Feature branches sync process completed."
