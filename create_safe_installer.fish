#!/usr/bin/env fish

# Safe GMP Installer - Preserves existing Fish configuration
# This script safely appends GMP functions to your existing config.fish

echo "🛡️ Safe GMP Installer"
echo "===================="
echo ""
echo "This installer will safely add GMP functions to your existing Fish configuration."
echo "Your existing config.fish will be preserved and backed up."
echo ""

# Check if config directory exists
set config_dir ~/.config/fish
set config_file $config_dir/config.fish
set functions_dir $config_dir/functions

# Create config directory if it doesn't exist
if not test -d $config_dir
    echo "📁 Creating Fish config directory..."
    mkdir -p $config_dir
end

# Create functions directory
if not test -d $functions_dir
    echo "📁 Creating Fish functions directory..."
    mkdir -p $functions_dir
end

# Backup existing config if it exists
if test -f $config_file
    set backup_file $config_file.backup.(date +%Y%m%d_%H%M%S)
    echo "💾 Backing up existing config to: $backup_file"
    cp $config_file $backup_file
    echo "✅ Backup created successfully"
else
    echo "📝 No existing config.fish found, will create new one"
end

echo ""
echo "🔧 Installation Options:"
echo "1. Append to config.fish (traditional method)"
echo "2. Create individual function files (recommended)"
echo "3. Both methods for maximum compatibility"
echo ""
echo -n "Choose option (1-3) [default: 2]: "
read -l choice

# Default to option 2 if no choice made
if test -z "$choice"
    set choice 2
end

set source_file "/Users/yo_macbook/Documents/dev/prompt_school/gmp_functions_to_append.fish"

# Check if source file exists
if not test -f $source_file
    echo "❌ Error: Source file not found at $source_file"
    echo "Please ensure the GMP functions file exists."
    exit 1
end

switch $choice
    case 1
        echo "📝 Appending functions to config.fish..."
        echo "" >> $config_file
        echo "# Added by GMP Safe Installer on (date)" >> $config_file
        cat $source_file >> $config_file
        echo "✅ Functions appended to config.fish"
        
    case 2
        echo "📂 Creating individual function files..."
        
        # Extract and create gmp.fish
        sed -n '/^function gmp -d/,/^end$/p' $source_file > $functions_dir/gmp.fish
        echo "✅ Created gmp.fish"
        
        # Extract and create gmp_edit.fish
        sed -n '/^function gmp_edit -d/,/^end$/p' $source_file > $functions_dir/gmp_edit.fish
        echo "✅ Created gmp_edit.fish"
        
        # Extract and create gmp_template.fish
        sed -n '/^function gmp_template -d/,/^end$/p' $source_file > $functions_dir/gmp_template.fish
        echo "✅ Created gmp_template.fish"
        
        # Extract and create gmp_help.fish
        sed -n '/^function gmp_help -d/,/^end$/p' $source_file > $functions_dir/gmp_help.fish
        echo "✅ Created gmp_help.fish"
        
    case 3
        echo "📝📂 Using both methods..."
        
        # Method 1: Append to config
        echo "" >> $config_file
        echo "# Added by GMP Safe Installer on (date)" >> $config_file
        cat $source_file >> $config_file
        echo "✅ Functions appended to config.fish"
        
        # Method 2: Individual files
        sed -n '/^function gmp -d/,/^end$/p' $source_file > $functions_dir/gmp.fish
        sed -n '/^function gmp_edit -d/,/^end$/p' $source_file > $functions_dir/gmp_edit.fish
        sed -n '/^function gmp_template -d/,/^end$/p' $source_file > $functions_dir/gmp_template.fish
        sed -n '/^function gmp_help -d/,/^end$/p' $source_file > $functions_dir/gmp_help.fish
        echo "✅ Individual function files created"
        
    case '*'
        echo "❌ Invalid choice. Please run the installer again."
        exit 1
end

echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "📋 Available commands:"
echo "  gmp 'description' [repo_url]     - Generate GitHub issue"
echo "  gmp_edit 'description' [repo_url] - Edit template before sending"
echo "  gmp_template                     - View current template"
echo "  gmp_help                         - Show detailed help"
echo ""
echo "🔄 To use the new functions:"
if test $choice -eq 1 -o $choice -eq 3
    echo "  source ~/.config/fish/config.fish"
else
    echo "  Functions are automatically available (restart terminal if needed)"
end
echo ""
echo "💡 Test with: gmp_help"
echo ""
echo "🛡️ Your original configuration has been safely preserved."
if test -f $backup_file
    echo "📁 Backup location: $backup_file"
end