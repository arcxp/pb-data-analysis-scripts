#!/bin/bash

# Get the options
Name=""
Csv=False
while getopts ":hn:c" option; do
  case $option in
    n) # Enter a name
      Name=$OPTARG;;
    c) # CSV output
      Csv=True;;
    h) # Help message
      echo "Usage: $0 -n name [-c]"
      echo "  -c for CSV output you can pipe to a file"
      exit 0;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done
# Check if the name is at least 2 characters long
if [[ -z "$Name" || ${#Name} -lt 2 ]]; then
  echo "Error: A content source name with at least 2 characters is required."
  exit 1
fi

QUERY="SELECT
	_id,
  priority,
	name,
	pattern,
	contentConfigMapping,
	content2pageMapping,
	defaultOutputType,
	note
FROM view_resolver
WHERE contentSourceId = '${Name}'
ORDER BY priority ASC, name ASC
"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- All resolvers using content source: ${Name} ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
