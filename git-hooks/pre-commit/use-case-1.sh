# Use Case: We create a files but never used in solution and forget those to remove all these files. At some time during clean up developers take time to identify all unused files and it is a big work for every one. To prevent all these, While commiting itself if we check if any unused file then commit should not trigger.
# We acheived using "pre-commit" hook.

#!/bin/sh

# Redirect output to stderr
exec 1>&2

echo "🔍 Checking for unused files before commit..."

# Get the list of newly added files in the commit
new_files=$(git diff --cached --name-only --diff-filter=A)

unused_files=()

for file in $new_files; do
    # Extract file name without extension
    filename=$(basename "$file")
    
    # Search if the filename is referenced anywhere in the project
    # (excluding .git folder and itself)
    if ! git grep -q "$filename" -- ':!'"$file" ':!.git'; then
        unused_files+=("$file")
    fi
done

# If there are unused files, block the commit
if [ ${#unused_files[@]} -gt 0 ]; then
    echo "❌ The following files are added but never used in the project:"
    for uf in "${unused_files[@]}"; do
        echo "   ➜ $uf"
    done
    echo "❌ Please remove these unused files before committing!"
    exit 1
fi

echo "✅ No unused files detected. Proceeding with commit."
exit 0
