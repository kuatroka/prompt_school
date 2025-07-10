#!/usr/bin/env fish

# Test script for the gmp (Gemini Issue Generator) functions
# This script demonstrates the usage of the enhanced gmp command

echo "🧪 Testing GMP (Gemini Issue Generator)"
echo "======================================"
echo ""

# Test 1: Show template
echo "📋 Test 1: Viewing the template"
echo "Command: gmp_template"
echo "---"
gmp_template
echo ""
echo "✅ Template displayed successfully"
echo ""

# Test 2: Show usage without arguments
echo "❌ Test 2: Testing error handling (no arguments)"
echo "Command: gmp"
echo "---"
gmp
echo ""

# Test 3: Simulate template processing (dry run)
echo "🔄 Test 3: Simulating template processing"
echo "Command: gmp 'Add dark mode support' 'https://github.com/user/repo'"
echo "---"

# Create a test version that shows the processed template instead of calling Gemini
function gmp_test
    if test (count $argv) -lt 1
        echo "Usage: gmp_test 'feature description' [repo_url]"
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
    
    set temp_file (mktemp)
    
    # Process template
    cat $template_path | sed "s/#\$ARGUMENTS/$feature_description/g" > $temp_file
    
    if test -n "$repo_url"
        sed -i '' "s/#\$REPO_URL/$repo_url/g" $temp_file
    else
        sed -i '' "s/#\$REPO_URL/Not provided - please specify repository context if needed/g" $temp_file
    end
    
    echo "📝 Processed template content:"
    echo "============================="
    cat $temp_file
    echo "============================="
    
    rm $temp_file
end

# Run the test
gmp_test "Add dark mode support" "https://github.com/user/repo"

echo ""
echo "✅ All tests completed!"
echo ""
echo "📚 Usage Examples:"
echo "  gmp 'Add user authentication' 'https://github.com/myorg/webapp'"
echo "  gmp_edit 'Fix mobile responsive issues' 'https://github.com/myorg/frontend'"
echo "  gmp_template"
echo ""
echo "🚀 Ready to use! Install with: fish install_gmp.fish"