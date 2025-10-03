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
  echo "Error: A chain name with at least 2 characters is required."
  exit 1
fi

QUERY="SELECT * FROM view_page_and_template
WHERE pageOrTemplateId IN (
  SELECT DISTINCT pageOrTemplateId
  FROM view_rendering
  LEFT JOIN view_page_and_template ON view_page_and_template.published = view_rendering.renderingVersionId
  WHERE pageOrTemplateId IS NOT NULL
    AND chainName = '${Name}'
)
ORDER BY
  view_page_and_template.isPageOrTemplate ASC,
  view_page_and_template.pageOrTemplateId ASC,
  view_page_and_template.uri ASC,
  view_page_and_template.name ASC"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- All published pages using chain: ${Name} ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
