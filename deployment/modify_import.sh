#!/bin/bash

# Define the file to process
TARGET_FILE="$1"

# Ensure a filename is provided
if [[ -z "$TARGET_FILE" ]]; then
  echo "Usage: $0 <python_file>"
  exit 1
fi

# Check if the file exists
if [[ ! -f "$TARGET_FILE" ]]; then
  echo "File not found: $TARGET_FILE"
  exit 1
fi

# Use awk to comment and insert lines
awk '
/sys\.path\.append\("..\/detr"\)/ {
  print "#" $0
  print "from pathlib import Path"
  print "import_script_path = (Path(__file__).resolve().parent / \"../detr\").resolve()"
  print "print(f\"Importing {import_script_path}\")"
  print "sys.path.append(str(import_script_path))"
  next
}
{ print }
' "$TARGET_FILE" > "${TARGET_FILE}.modified" && mv "${TARGET_FILE}.modified" "$TARGET_FILE"

echo "Modifications completed for $TARGET_FILE"
