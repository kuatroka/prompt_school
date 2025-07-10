# Enhanced gmp function for GitHub issue generation
# Usage: gmp "feature description" [repo_url]
# Example: gmp "Add dark mode support" "https://github.com/user/repo"

function gmp
    # Check if at least one argument is provided
    if test (count $argv) -lt 1
        echo "Usage: gmp 'feature description' [repo_url]"
        echo "Example: gmp 'Add dark mode support' 'https://github.com/user/repo'"
        return 1
    end
    
    # Get the feature description (first argument)
    set feature_description $argv[1]
    
    # Get the repo URL (second argument, optional)
    set repo_url ""
    if test (count $argv) -ge 2
        set repo_url $argv[2]
    end
    
    # Path to the template file
    set template_path "/Users/yo_macbook/Documents/dev/prompt_school/kieran_prompt/.gemini/commands/issues.md"
    
    # Check if template file exists
    if not test -f $template_path
        echo "Error: Template file not found at $template_path"
        return 1
    end
    
    # Create a temporary file for the processed template
    set temp_file (mktemp)
    
    # Read the template and substitute placeholders
    cat $template_path | sed "s/#\$ARGUMENTS/$feature_description/g" > $temp_file
    
    # Handle repo_url substitution
    if test -n "$repo_url"
        sed -i '' "s/#\$REPO_URL/$repo_url/g" $temp_file
    else
        sed -i '' "s/#\$REPO_URL/Not provided - please specify repository context if needed/g" $temp_file
    end
    
    # Launch gemini with the processed template
    echo "Launching Gemini with processed template..."
    echo "Feature: $feature_description"
    if test -n "$repo_url"
        echo "Repository: $repo_url"
    end
    echo "---"
    
    # Use the processed template as the prompt
    command gemini --prompt (cat $temp_file)
    
    # Clean up temporary file
    rm $temp_file
end

# Alternative function for when you want to edit the template before sending
function gmp_edit
    # Check if at least one argument is provided
    if test (count $argv) -lt 1
        echo "Usage: gmp_edit 'feature description' [repo_url]"
        return 1
    end
    
    set feature_description $argv[1]
    set repo_url ""
    if test (count $argv) -ge 2
        set repo_url $argv[2]
    end
    
    set template_path "/Users/yo_macbook/Documents/dev/prompt_school/kieran_prompt/.gemini/commands/issues.md"
    
    if not test -f $template_path
        echo "Error: Template file not found at $template_path"
        return 1
    end
    
    # Create a temporary file for editing
    set temp_file (mktemp --suffix=.md)
    
    # Process template with placeholder substitution
    cat $template_path | sed "s/#\$ARGUMENTS/$feature_description/g" > $temp_file
    
    # Handle repo_url substitution
    if test -n "$repo_url"
        sed -i '' "s/#\$REPO_URL/$repo_url/g" $temp_file
    else
        sed -i '' "s/#\$REPO_URL/Not provided - please specify repository context if needed/g" $temp_file
    end
    
    # Open in default editor for review/editing
    $EDITOR $temp_file
    
    # Ask if user wants to proceed
    echo "Press Enter to send to Gemini, or Ctrl+C to cancel"
    read
    
    # Launch gemini
    command gemini --prompt (cat $temp_file)
    
    # Clean up
    rm $temp_file
end

# Helper function to show template content
function gmp_template
    set template_path "/Users/yo_macbook/Documents/dev/prompt_school/kieran_prompt/.gemini/commands/issues.md"
    if test -f $template_path
        cat $template_path
    else
        echo "Template file not found at $template_path"
    end
end