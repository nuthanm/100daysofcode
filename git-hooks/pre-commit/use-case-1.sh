#!/bin/bash

# Redirect all output to stderr
exec 1>&2

echo "🔍 Checking for unused files before commit..."

# Get all newly added files (staged)
new_files=$(git diff --cached --name-only --diff-filter=A)

unused_files=()

for file in $new_files; do
    # Get just the filename without the path
    filename=$(basename "$file")

    # Remove extension (e.g., .cs, .js) to get the base name
    base_name="${filename%.*}"

    # Skip empty filenames or special cases
    if [ -z "$base_name" ]; then
        continue
    fi

    # Check if base name is used anywhere in the repo (excluding the file itself and .git folder)
    if ! git grep -q "$base_name" -- ':(exclude)'"$file" ':!*.git*'; then
        unused_files+=("$file")
    fi
done

if [ ${#unused_files[@]} -gt 0 ]; then
    echo "❌ The following files are added but never used in the project:"
    for uf in "${unused_files[@]}"; do
        echo "   ➜ $uf"
    done
    echo "❌ Please remove or reference these files before committing!"
    exit 1
fi

echo "✅ All newly added files are used somewhere in the project. Proceeding with commit."
exit 0
