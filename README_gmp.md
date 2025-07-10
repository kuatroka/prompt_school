# GMP - Gemini Issue Generator

A Fish shell function that enhances your workflow by automatically generating well-structured GitHub issues using Google's Gemini AI.

## Features

- 🎯 **Template-based**: Uses a predefined template for consistent issue generation
- 🔄 **Variable substitution**: Automatically replaces `#$ARGUMENTS` with your feature description
- 🔗 **Repository integration**: Optional repo URL parameter for context-aware issues
- ✏️ **Edit mode**: Review and modify the template before sending to Gemini
- 🚀 **One-command execution**: Generate issues with a single command

## Installation

### Option 1: Quick Install (Recommended)

```bash
# Make the installer executable and run it
chmod +x /Users/yo_macbook/Documents/dev/prompt_school/install_gmp.fish
fish /Users/yo_macbook/Documents/dev/prompt_school/install_gmp.fish
```

### Option 2: Manual Installation

1. Copy the functions to your Fish functions directory:
```bash
mkdir -p ~/.config/fish/functions
cp /Users/yo_macbook/Documents/dev/prompt_school/config.fish ~/.config/fish/functions/
```

2. Restart your Fish shell or reload the configuration:
```bash
source ~/.config/fish/config.fish
```

## Usage

### Basic Usage

```bash
# Generate an issue with just a description
gmp "Add dark mode support"

# Generate an issue with description and repository URL
gmp "Fix login bug" "https://github.com/username/repository"
```

### Advanced Usage

```bash
# Edit the template before sending (opens in your default editor)
gmp_edit "Add user authentication" "https://github.com/myorg/myapp"

# View the current template
gmp_template
```

## How It Works

1. **Template Processing**: The function reads the issue template from `/Users/yo_macbook/Documents/dev/prompt_school/kieran_prompt/.gemini/commands/issues.md`

2. **Variable Substitution**: Replaces `#$ARGUMENTS` with your feature description

3. **Repository Context**: If provided, adds the repository URL to give Gemini context about the project

4. **Gemini Integration**: Sends the processed template to Gemini AI for issue generation

## Template Structure

The template includes:
- Feature description placeholder (`#$ARGUMENTS`)
- Repository research instructions
- Best practices guidelines
- Structured output format
- GitHub CLI integration hints

## Available Functions

| Function | Description | Usage |
|----------|-------------|-------|
| `gmp` | Generate GitHub issue directly | `gmp "description" [repo_url]` |
| `gmp_edit` | Edit template before generation | `gmp_edit "description" [repo_url]` |
| `gmp_template` | View the current template | `gmp_template` |

## Examples

### Feature Request
```bash
gmp "Add support for multiple themes" "https://github.com/mycompany/webapp"
```

### Bug Report
```bash
gmp "Login form validation fails on mobile devices" "https://github.com/mycompany/mobileapp"
```

### Enhancement
```bash
gmp "Improve API response time for user queries" "https://github.com/mycompany/backend"
```

## Prerequisites

- Fish shell
- Google Gemini CLI tool installed and configured
- Access to the template file at the specified path

## Troubleshooting

### Function not found
```bash
# Reload Fish configuration
source ~/.config/fish/config.fish

# Or restart your terminal
```

### Template file not found
Ensure the template exists at:
```
/Users/yo_macbook/Documents/dev/prompt_school/kieran_prompt/.gemini/commands/issues.md
```

### Gemini CLI not working
```bash
# Check if Gemini CLI is installed
which gemini

# Test Gemini CLI
gemini --help
```

## Customization

### Modify Template Path
Edit the `template_path` variable in the function files:
```fish
set template_path "/path/to/your/custom/template.md"
```

### Add Custom Parameters
You can extend the functions to accept additional parameters like:
- Issue labels
- Assignees
- Milestones
- Priority levels

## Contributing

Feel free to enhance these functions by:
- Adding more template variables
- Improving error handling
- Adding support for different AI models
- Creating additional templates for different issue types

## License

This tool is provided as-is for educational and productivity purposes.