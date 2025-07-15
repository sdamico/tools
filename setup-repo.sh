#!/bin/bash

# Script to set up the GitHub repository
# Run this from the tools-repo directory

echo "Setting up GitHub repository..."

# Initialize git if needed
if [ ! -d .git ]; then
    git init
    echo "Initialized git repository"
fi

# Add remote if not already added
if ! git remote | grep -q origin; then
    git remote add origin https://github.com/sdamico/tools.git
    echo "Added GitHub remote"
fi

# Create initial commit
git add .
git commit -m "Initial commit: Grok AI CLI tools

- Complete suite of Grok CLI tools
- Installation script
- Comprehensive documentation
- Example contexts and usage
- MIT License"

echo
echo "Repository ready!"
echo
echo "To push to GitHub:"
echo "  git push -u origin main"
echo
echo "Note: Make sure you've created the repository on GitHub first"