# Grok AI CLI Tools

A comprehensive suite of command-line tools for interacting with Grok AI via the xAI API.

## Prerequisites

- Bash 4.0+
- curl
- jq (for JSON processing)
- base64 (for image support)
- A Grok API key from [x.ai](https://x.ai)

## Installation

### Quick Install

```bash
./install.sh
```

This will:
1. Check for required dependencies (curl, jq, base64)
2. Copy all tools to `~/bin`
3. Set up contexts in `~/.grok/contexts`
4. Add `~/bin` to your PATH (if needed)
5. Create a config file at `~/.grok/config` with your API key
6. Verify the installation

### Updating

To update to the latest version:

```bash
grok-update
```

This will:
- Fetch the latest changes from GitHub
- Show you what's new
- Update your tools while preserving your local config

### Manual Installation

1. Copy the scripts to your preferred location (e.g., `~/bin`)
2. Make them executable: `chmod +x ~/bin/grok*`
3. Copy contexts to `~/.grok/contexts/`
4. Ensure the directory is in your PATH

### API Key Setup

During installation, you'll be prompted to enter your Grok API key. The installer will create a configuration file at `~/.grok/config` to store your API key securely.

If you need to update your API key later, edit the config file:

```bash
# Edit the config file
nano ~/.grok/config
```

The config file format:
```bash
#!/bin/bash
# Local Grok configuration - DO NOT COMMIT TO GIT!

# API Configuration
export GROK_API_KEY="your-api-key-here"
export GROK_API_ENDPOINT="https://api.x.ai/v1"

# Default model
export GROK_MODEL="grok-4-0709"
```

**Important**: The config file is automatically excluded from git and has restricted permissions (600) for security.

## Tools Reference

### grok - Main Interface

The primary tool for interacting with Grok.

```bash
grok [OPTIONS] "prompt"
```

**Options:**
- `-c, --context NAME` - Use a predefined context from ~/.grok/contexts/
- `-s, --system PROMPT` - Set a custom system prompt
- `-f, --file FILE` - Include file content (can be used multiple times)
- `-i, --image IMAGE` - Include images/screenshots (can be used multiple times)
- `-x, --execute` - Execute shell commands from response (with confirmation)
- `-m, --model MODEL` - Use specific model (default: grok-4-0709)
- `-t, --temperature NUM` - Set temperature 0-2 (default: 0.7)

**Examples:**
```bash
# Simple query
grok "What is quantum computing?"

# Code review with context
grok -c code-review -f app.py "Find security issues"

# Multi-file analysis
grok -f main.py -f utils.py "How are these files related?"

# Image analysis
grok -i ui-mockup.png -c designer "Suggest improvements"

# Execute commands
grok -x "Show disk usage by directory"
```

### grok-advanced - Power Features

Enhanced capabilities for complex workflows.

```bash
grok-advanced [OPTIONS] "prompt"
```

**Additional Options:**
- `--stream` - Stream responses in real-time
- `--conversation ID` - Continue a named conversation
- `--format FORMAT` - Output format: markdown, json, or plain
- `--max-tokens N` - Limit response length
- `--retry N` - Number of retry attempts

**Examples:**
```bash
# Streaming response
grok-advanced --stream "Write a detailed analysis"

# Continue conversation
grok-advanced --conversation project1 "Let's design an API"
grok-advanced --conversation project1 "Add authentication"

# JSON output
grok-advanced --format json "List 5 Python tips" | jq
```

### grok-chat - Interactive Mode

Terminal-based interactive chat interface.

```bash
grok-chat [conversation-name]
```

**Commands within chat:**
- `exit` or `quit` - Exit the chat
- `clear` - Start a new conversation
- `save` - Save the current conversation

### grok-shell - Command Execution

Specialized tool for system administration tasks.

```bash
grok-shell [OPTIONS] "task description"
```

**Options:**
- `-y, --yes` - Auto-execute commands (YOLO mode - use with caution!)
- `-i, --interactive` - Interactive mode for multiple commands
- `-c, --context` - Provide system context (e.g., "ubuntu", "macos")

**Examples:**
```bash
# With confirmation
grok-shell "clean up docker containers"

# Auto-execute (dangerous!)
grok-shell -y "show system information"

# Interactive mode
grok-shell -i
```

### grok-codebase - Project Analysis

Analyze entire codebases efficiently.

```bash
grok-codebase [OPTIONS] PATH "prompt"
```

**Options:**
- `-e, --extensions` - File extensions to include (default: common code files)
- `-i, --ignore` - Patterns to ignore (default: node_modules, .git, etc.)
- `--max-files` - Maximum number of files to analyze

**Examples:**
```bash
# Analyze current directory
grok-codebase . "Explain the architecture"

# Specific file types
grok-codebase -e py,js src/ "Find potential bugs"

# Ignore test files
grok-codebase --ignore test,spec . "Review production code"
```

### grok-help - Documentation

Display comprehensive help and examples.

```bash
grok-help
```

## Contexts

Contexts are pre-configured system prompts that specialize Grok for specific tasks. They're stored in `~/.grok/contexts/`.

### Built-in Contexts

- **code-review** - Expert code reviewer focusing on security, performance, and best practices
- **controls** - Control systems engineer specializing in PID tuning and temperature control
- **designer** - UI/UX expert for design analysis and implementation suggestions
- **analyst** - Data and document analysis specialist
- **debug** - Debugging and troubleshooting expert

### Creating Custom Contexts

1. Create a text file in `~/.grok/contexts/` with your context name (e.g., `mycontext.txt`)
2. Write a system prompt that defines the expertise and behavior
3. Use it with: `grok -c mycontext "your prompt"`

Example context file (`~/.grok/contexts/security.txt`):
```
You are a cybersecurity expert specializing in application security, penetration testing, and secure coding practices. When analyzing code or systems:

1. Identify potential vulnerabilities (OWASP Top 10, CWEs)
2. Suggest specific remediation steps
3. Provide secure code examples
4. Consider the full attack surface
5. Prioritize findings by severity

Be specific about the security implications and provide actionable recommendations.
```

## Advanced Usage

### Pipe Support

All tools support piping input:

```bash
# Analyze command output
docker logs myapp | grok -c debug "What went wrong?"

# Process file listings
ls -la | grok "Which files should I archive?"

# Git integration
git diff | grok "Write a commit message"
```

### Combining Tools

The tools work well together:

```bash
# Use grok to analyze, then execute
grok -f config.json "Generate commands to optimize these settings" | \
  grok-shell -y

# Analyze codebase, then review specific files
grok-codebase . "Which files need security review?" | \
  xargs -I {} grok -c code-review -f {} "Security audit"
```

### Configuration

Grok tools use a configuration file at `~/.grok/config` that is automatically created during installation. This file contains:

- `GROK_API_KEY` - Your xAI API key (required)
- `GROK_API_ENDPOINT` - API endpoint (default: https://api.x.ai/v1)
- `GROK_MODEL` - Default model to use (default: grok-4-0709)

Additional environment variables:
- `GROK_CONFIG_DIR` - Configuration directory (default: ~/.grok)
- `GROK_DEBUG` - Set to 1 for debug output

## Troubleshooting

### Common Issues

1. **"GROK_API_KEY environment variable is not set"**
   - Check if config file exists: `ls ~/.grok/config`
   - If missing, run the installer again: `./install.sh`
   - Or create it manually: `nano ~/.grok/config`

2. **"jq: command not found"**
   - Install jq: `brew install jq` (macOS) or `apt install jq` (Ubuntu)

3. **"Permission denied"**
   - Make scripts executable: `chmod +x ~/bin/grok*`

4. **JSON parsing errors**
   - Update to the latest version - older versions had escaping issues

### Debug Mode

Set `GROK_DEBUG=1` to see detailed API requests and responses:

```bash
GROK_DEBUG=1 grok "test query"
```

## Security Considerations

- **API Key**: Stored in `~/.grok/config` with restricted permissions (600)
- **Config File**: Automatically excluded from git via .gitignore
- **Shell Execution**: Be careful with `-x` flag and `grok-shell -y`
- **File Access**: The tools can read any file you have access to
- **Network**: All requests go to xAI's API over HTTPS

**Important**: Never commit your config file to version control. The installer creates it with proper permissions and the repository's .gitignore excludes it automatically.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Acknowledgments

- Built for use with Grok AI by xAI
- Inspired by similar tools for other AI assistants
- Thanks to all contributors and users

## Support

- Report issues on [GitHub](https://github.com/sdamico/tools)
- Check the built-in help: `grok-help`
- Review example usage in the contexts directory