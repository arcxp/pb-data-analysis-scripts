#!/bin/bash

# Get the options
Csv=False
while getopts ":hn:c" option; do
  case $option in
    c) # CSV output
      Csv=True;;
    h) # Help message
      echo "Usage: $0 [-c]"
      echo "  -c for CSV output you can pipe to a file"
      exit 0;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done

QUERY="SELECT * FROM (
  SELECT
    contentSourceId,
    COUNT(1) as countOfResolvers
  FROM view_resolver
  GROUP BY contentSourceId
)
ORDER BY countOfResolvers DESC"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- Global content sources in resolvers ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
