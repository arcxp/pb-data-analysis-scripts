#!/bin/bash

YELLOW='\033[0;33m'
RESET='\033[0m'

echo "${YELLOW}\n--- Convert bson files to jsonl files ---\n${RESET}"
DIRECTORY="pb-data"
# Loop through each .bson file in the directory
for file in "$DIRECTORY"/*.bson; do
  # Get the base name of the file without the directory
  base_name=$(basename "$file" .bson)
  # Run bsondump and output to a .json file with the same base name
  bsondump --outFile "$DIRECTORY/$base_name.json" "$file"
done


echo "${YELLOW}\n--- Create a temp duckdb database with views ---\n${RESET}"
rm -f _tmpview.db
duckdb _tmpview.db < _duckdb-views.sql
echo 'DONE'
