# Grok Tools Examples

A collection of practical examples showing how to use the Grok CLI tools effectively.

## Basic Usage

### Simple Queries

```bash
# Ask a question
grok "What is the capital of France?"

# Get help with a task
grok "How do I check disk usage on Linux?"

# Explain a concept
grok "Explain machine learning in simple terms"
```

### Working with Files

```bash
# Analyze a single file
grok -f script.py "What does this script do?"

# Review code for issues
grok -f app.js "Find potential bugs in this code"

# Compare multiple files
grok -f old_version.py -f new_version.py "What changed between these versions?"

# Analyze configuration
grok -f config.json "Are there any security issues with this configuration?"
```

### Using Contexts

```bash
# Code review with specialized context
grok -c code-review -f api.py "Review this REST API implementation"

# Debug an error
grok -c debug -f error.log "What caused this crash?"

# Analyze data
grok -c analyst -f report.csv "Summarize the key trends"

# Get UI/UX feedback
grok -c designer -i screenshot.png "How can I improve this interface?"

# Control systems help
grok -c controls "Design a PID controller for a water heater"
```

## Advanced Features

### Shell Command Execution

```bash
# Get commands with confirmation
grok -x "Find all Python files modified in the last week"

# System administration
grok-shell "Clean up old Docker images"

# Auto-execute mode (use carefully!)
grok-shell -y "Show current system resources"

# Interactive shell mode
grok-shell -i
```

### Streaming and Conversations

```bash
# Stream long responses
grok-advanced --stream "Write a detailed guide to Python decorators"

# Start a conversation
grok-advanced --conversation myproject "Let's design a REST API"

# Continue the conversation
grok-advanced --conversation myproject "Now add authentication"

# Review conversation history
cat ~/.grok/conversations/myproject.json | jq

# Interactive chat
grok-chat
```

### Working with Images

```bash
# Analyze a screenshot
grok -i screenshot.png "What's wrong with this error message?"

# Compare designs
grok -i design_v1.png -i design_v2.png "Which design is better and why?"

# Get implementation help
grok -i mockup.jpg -c designer "Generate HTML/CSS for this design"

# Combine with code
grok -i ui.png -f App.jsx "Update the component to match this design"
```

### Codebase Analysis

```bash
# Analyze entire project
grok-codebase . "Explain the architecture of this project"

# Focus on specific file types
grok-codebase -e py,js src/ "Find security vulnerabilities"

# Ignore test files
grok-codebase --ignore test,spec . "Review only production code"

# Limited file count
grok-codebase --max-files 20 . "What are the main components?"
```

## Practical Workflows

### Code Review Workflow

```bash
# 1. Get overview
grok-codebase . "What does this project do?"

# 2. Review specific changes
git diff main | grok -c code-review "Review these changes"

# 3. Check for security issues
grok -c code-review -f auth.py -f api.py "Any security vulnerabilities?"

# 4. Generate documentation
grok -f main.py "Write docstrings for all functions"
```

### Debugging Workflow

```bash
# 1. Analyze error
grok -c debug -f error.log "What's causing this error?"

# 2. Get diagnostic commands
grok -x "Show me how to debug a memory leak in Python"

# 3. Review problematic code
grok -c debug -f module.py "Why might this code cause a memory leak?"

# 4. Get fix suggestions
grok -f module.py "How can I fix the memory leak?"
```

### Learning Workflow

```bash
# 1. Start with concepts
grok "Explain async/await in JavaScript"

# 2. See examples
grok "Show me practical examples of async/await"

# 3. Review real code
grok -f async_code.js "Is this using async/await correctly?"

# 4. Interactive exploration
grok-chat learning-session
```

### System Administration

```bash
# 1. Get system info
grok-shell "Show system resource usage"

# 2. Find issues
df -h | grok "Which partitions need attention?"

# 3. Get cleanup commands
grok-shell "Help me free up disk space"

# 4. Monitor logs
tail -f /var/log/syslog | grok -c debug
```

## Output Formats

```bash
# Default markdown output
grok "List 5 Python tips"

# JSON output for scripting
grok-advanced --format json "List Python tips" | jq '.response'

# Plain text (no formatting)
grok-advanced --format plain "Explain REST APIs"

# Parse structured data
grok-advanced --format json "Extract names from: John (25), Jane (30)" | \
  jq -r '.response | fromjson | .[]'
```

## Integration Examples

### Git Integration

```bash
# Generate commit message
git diff --cached | grok "Write a commit message"

# Review before pushing
git diff origin/main | grok -c code-review "Should I push these changes?"

# Explain changes
git log --oneline -10 | grok "Summarize recent changes"
```

### Docker Integration

```bash
# Analyze Dockerfile
grok -f Dockerfile "Optimize this for smaller image size"

# Debug containers
docker logs myapp | grok -c debug "Why is this crashing?"

# Compose help
grok -f docker-compose.yml "Add a Redis service"
```

### CI/CD Integration

```bash
# Review pipeline
grok -f .github/workflows/ci.yml "Add test coverage reporting"

# Analyze build failure
cat build.log | grok -c debug "Why did the build fail?"

# Security scanning
grok -c code-review -f .github/workflows/deploy.yml "Any security concerns?"
```

## Tips and Tricks

### Performance

```bash
# For large files, use specific questions
grok -f large_file.py "What does the main() function do?"

# Limit codebase analysis
grok-codebase --max-files 50 . "Overview of architecture"

# Stream for long responses
grok-advanced --stream "Explain all Python built-in functions"
```

### Accuracy

```bash
# Be specific with questions
# Bad: "Fix this"
# Good: "Fix the SQL injection vulnerability in the login function"

# Provide context
grok -s "This is a Django app" -f views.py "Add pagination"

# Use appropriate contexts
grok -c controls "Tune PID for 1L water, 1kW heater"
```

### Safety

```bash
# Review before executing
grok -x "Delete old logs" # Shows commands first

# Test in dry-run when possible
grok "Show me the rm command with --dry-run for old logs"

# Use contexts for expertise
grok -c code-review "Is this SQL query safe?"
```

## Creating Custom Workflows

### Custom Context Example

Create `~/.grok/contexts/terraform.txt`:
```
You are a Terraform and infrastructure-as-code expert. When reviewing Terraform code:
- Check for security best practices
- Suggest cost optimizations
- Ensure proper state management
- Validate resource naming conventions
- Identify potential race conditions
```

Use it:
```bash
grok -c terraform -f main.tf "Review this infrastructure"
```

### Batch Processing

```bash
# Review all Python files
for file in *.py; do
    echo "=== $file ==="
    grok -c code-review -f "$file" "Any issues?"
done

# Process images
for img in screenshots/*.png; do
    grok -i "$img" -c designer "Rate this UI from 1-10"
done
```

### Custom Scripts

```bash
#!/bin/bash
# grok-pr-review - Review a pull request

PR_BRANCH=$1
BASE_BRANCH=${2:-main}

echo "Reviewing PR: $PR_BRANCH against $BASE_BRANCH"

# Get the diff
git diff $BASE_BRANCH..$PR_BRANCH > /tmp/pr-diff.txt

# Review changes
grok -c code-review -f /tmp/pr-diff.txt "Review this pull request"

# Check for specific issues
echo -e "\nSecurity Check:"
grok -c code-review -f /tmp/pr-diff.txt "Any security vulnerabilities?"

echo -e "\nPerformance Check:"
grok -c code-review -f /tmp/pr-diff.txt "Any performance concerns?"
```

Save as `grok-pr-review`, make executable, and use:
```bash
grok-pr-review feature-branch main
```