#!/bin/bash

# Grok Tools Installation Script

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directories
BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.grok"
CONTEXTS_DIR="$CONFIG_DIR/contexts"

echo -e "${GREEN}Grok Tools Installer${NC}"
echo "===================="
echo

# Check for required dependencies
echo "Checking dependencies..."
missing_deps=()

for cmd in curl jq base64; do
    if ! command -v $cmd &> /dev/null; then
        missing_deps+=($cmd)
    fi
done

if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "${RED}Error: Missing required dependencies: ${missing_deps[*]}${NC}"
    echo "Please install them first:"
    echo "  macOS: brew install ${missing_deps[*]}"
    echo "  Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
    exit 1
fi

echo -e "${GREEN}✓${NC} All dependencies found"

# Create directories
echo
echo "Creating directories..."
mkdir -p "$BIN_DIR"
mkdir -p "$CONTEXTS_DIR"
mkdir -p "$CONFIG_DIR/conversations"

# Copy scripts
echo "Installing scripts..."
for script in bin/grok*; do
    script_name=$(basename "$script")
    cp "$script" "$BIN_DIR/"
    chmod +x "$BIN_DIR/$script_name"
    echo -e "  ${GREEN}✓${NC} $script_name"
done

# Copy contexts
echo
echo "Installing contexts..."
if [ -d "contexts" ] && [ "$(ls -A contexts)" ]; then
    cp contexts/*.txt "$CONTEXTS_DIR/" 2>/dev/null || true
    for context in contexts/*.txt; do
        if [ -f "$context" ]; then
            context_name=$(basename "$context")
            echo -e "  ${GREEN}✓${NC} $context_name"
        fi
    done
else
    echo -e "  ${YELLOW}No contexts found to install${NC}"
fi

# Check if ~/bin is in PATH
echo
echo "Checking PATH..."
if [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    echo -e "  ${GREEN}✓${NC} $HOME/bin is already in PATH"
else
    echo -e "  ${YELLOW}!${NC} $HOME/bin is not in PATH"
    
    # Detect shell and update config
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    else
        SHELL_CONFIG="$HOME/.profile"
    fi
    
    echo "  Adding to $SHELL_CONFIG..."
    echo "" >> "$SHELL_CONFIG"
    echo "# Added by Grok Tools installer" >> "$SHELL_CONFIG"
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$SHELL_CONFIG"
    echo -e "  ${GREEN}✓${NC} PATH updated"
    echo
    echo -e "  ${YELLOW}Note:${NC} Run 'source $SHELL_CONFIG' or restart your terminal"
fi

# Check for API key
echo
echo "Checking API key..."
if [ -n "$GROK_API_KEY" ]; then
    echo -e "  ${GREEN}✓${NC} GROK_API_KEY is set"
else
    echo -e "  ${YELLOW}!${NC} GROK_API_KEY is not set"
    echo
    echo "To use Grok tools, you need to set your API key:"
    echo "  export GROK_API_KEY=\"your-api-key-here\""
    echo
    echo "Get your API key from: https://x.ai"
    echo
    echo "Add it to your shell config to make it permanent:"
    echo "  echo 'export GROK_API_KEY=\"your-api-key\"' >> $SHELL_CONFIG"
fi

# Test installation
echo
echo "Testing installation..."
if command -v grok-help &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Installation successful!"
    echo
    echo "Run 'grok-help' for documentation"
else
    echo -e "  ${YELLOW}!${NC} Installation complete but 'grok-help' not found in PATH"
    echo "  You may need to run: source $SHELL_CONFIG"
fi

echo
echo -e "${GREEN}Installation complete!${NC}"
echo
echo "Quick start:"
echo "  grok \"Hello, what can you do?\""
echo "  grok-help    # Show full documentation"
echo "  grok-chat    # Start interactive chat"