# Tools Collection

A collection of useful command-line tools and utilities.

## Grok - AI Assistant CLI Tools

A comprehensive suite of command-line tools for interacting with Grok AI (via xAI API). These tools provide a powerful interface for code analysis, file processing, image understanding, and interactive AI assistance.

### Features

- 🚀 **Multiple interfaces**: Basic CLI, advanced features, interactive chat, and more
- 📁 **Multi-file analysis**: Analyze entire codebases or multiple files at once
- 🖼️ **Image support**: Analyze screenshots and images with AI
- 💬 **Conversation memory**: Continue conversations across sessions
- 🔧 **Shell integration**: Execute suggested commands with confirmation
- 🎯 **Specialized contexts**: Pre-configured for code review, debugging, controls engineering, and more
- 🔄 **Streaming responses**: Real-time output for long responses

### Quick Start

1. **Get an API Key**: Sign up at [x.ai](https://x.ai) to get your Grok API key

2. **Install**: 
   ```bash
   cd grok
   ./install.sh
   ```

3. **Set your API key**:
   ```bash
   export GROK_API_KEY="your-api-key-here"
   ```

4. **Start using Grok**:
   ```bash
   grok "Hello, what can you do?"
   ```

### Tools Overview

- **`grok`** - Main interface with file/image/execution support
- **`grok-advanced`** - Streaming, conversations, output formats
- **`grok-chat`** - Interactive terminal chat
- **`grok-codebase`** - Whole project analysis
- **`grok-shell`** - Command execution helper
- **`grok-help`** - Complete documentation

### Example Usage

```bash
# Basic query
grok "Explain the theory of relativity"

# Analyze code
grok -f main.py "Review this code for bugs"

# Multi-file analysis
grok -f server.py -f client.py "How do these interact?"

# Image analysis
grok -i screenshot.png "What improvements would you suggest?"

# Use specialized context
grok -c code-review -f api.js "Security audit this file"

# Execute shell commands
grok -x "Find all Python files modified this week"

# Interactive chat
grok-chat

# Analyze entire project
grok-codebase . "Explain the architecture"
```

### Available Contexts

Pre-configured expert contexts in `contexts/`:
- `code-review` - Security, performance, and best practices
- `controls` - Control systems and PID tuning
- `designer` - UI/UX analysis and implementation
- `analyst` - Document and data analysis
- `debug` - Error diagnosis and troubleshooting

### Documentation

See the [Grok README](grok/README.md) for detailed documentation, advanced usage, and configuration options.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## License

MIT License - see LICENSE file for details.