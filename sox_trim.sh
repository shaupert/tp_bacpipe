#!/bin/bash

# Target directory (defaults to current directory if not provided)
TARGET_DIR="${1:-.}"

echo "Scanning '$TARGET_DIR' for audio files..."

# Find supported audio extensions (wav, mp3, flac, ogg, aiff)
find "$TARGET_DIR" -type f \( -name "*.wav" -o -name "*.mp3" -o -name "*.flac" -o -name "*.ogg" -o -name "*.aiff" \) | while read -r file; do
    echo "Processing: $file"
    
    # Create temporary file in the same format/directory
    ext="${file##*.}"
    temp_file="${file%.*}.tmp_trim.${ext}"
    
    # Trim to 3 seconds starting from position 0
    if sox "$file" "$temp_file" trim 0 3; then
        mv "$temp_file" "$file"
    else
        echo "Error processing $file"
        rm -f "$temp_file"
    fi
done

echo "Done! All matching audio files trimmed."
