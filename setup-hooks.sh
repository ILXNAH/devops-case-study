#!/bin/bash

echo "Setting up Git hooks..."

# Copy the hooks from the repository to the .git/hooks/ directory
cp hooks/post-checkout .git/hooks/post-checkout

# Ensure the script is executable
chmod +x .git/hooks/post-checkout

echo "Git hooks have been successfully set up!"
