#!/bin/bash

# Get the options
Csv=False
while getopts ":hn:c" option; do
  case $option in
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

QUERY="SELECT pageOrTemplateId, uri, name
FROM view_page_and_template
WHERE isPageOrTemplate = 'Page'
  AND published IS NOT NULL"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- All published pages: ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
