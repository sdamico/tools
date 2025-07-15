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

# Create or check config file
echo
echo "Setting up configuration..."
CONFIG_FILE="$CONFIG_DIR/config"

if [ -f "$CONFIG_FILE" ]; then
    echo -e "  ${GREEN}✓${NC} Config file already exists at $CONFIG_FILE"
    # Source it to check if API key is set
    source "$CONFIG_FILE"
else
    echo -e "  Creating config file at $CONFIG_FILE"
    
    # Check for API key in environment
    if [ -n "$GROK_API_KEY" ]; then
        echo -e "  ${GREEN}✓${NC} Found GROK_API_KEY in environment"
        API_KEY_TO_USE="$GROK_API_KEY"
    else
        echo -e "  ${YELLOW}!${NC} No GROK_API_KEY found"
        echo
        echo "To use Grok tools, you need an API key from https://x.ai"
        echo -n "Enter your Grok API key (or press Enter to set it later): "
        read -r API_KEY_TO_USE
    fi
    
    # Create config file
    cat > "$CONFIG_FILE" << EOF
#!/bin/bash
# Local Grok configuration - DO NOT COMMIT TO GIT!

# API Configuration
export GROK_API_KEY="${API_KEY_TO_USE}"
export GROK_API_ENDPOINT="https://api.x.ai/v1"

# Default model
export GROK_MODEL="grok-4-0709"

# Optional settings
# export GROK_DEBUG=1  # Uncomment for debug mode
# export GROK_CONFIG_DIR="\$HOME/.grok"
EOF
    
    chmod 600 "$CONFIG_FILE"  # Restrict permissions
    echo -e "  ${GREEN}✓${NC} Config file created"
    
    if [ -z "$API_KEY_TO_USE" ]; then
        echo
        echo -e "  ${YELLOW}Important:${NC} Edit $CONFIG_FILE to add your API key"
    fi
fi

# Check if API key is configured
source "$CONFIG_FILE" 2>/dev/null || true
if [ -n "$GROK_API_KEY" ] && [ "$GROK_API_KEY" != "" ]; then
    echo -e "  ${GREEN}✓${NC} API key is configured"
else
    echo -e "  ${YELLOW}!${NC} API key not configured"
    echo "  Edit $CONFIG_FILE and add your API key"
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