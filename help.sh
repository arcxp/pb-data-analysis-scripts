#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

echo "${YELLOW}Available scripts and their usage:${RESET}

📄 ${GREEN}describe-page-or-template.sh${RESET} -i <page_or_template_id>
   Describe a specific page or template with its chains, features, and content sources
   -i: Page or Template ID (required, min 2 characters)

📁 ${GREEN}all-chains-usage.sh${RESET} [-c]
   Shows all chains used in published pages, templates and how many times they are used
   -c: Output in CSV format

🔍 ${GREEN}find-pages-by-chain-name.sh${RESET} -n <chain_name> [-c]
   Find all pages using a specific chain
   -n: Chain name (required, min 2 characters)
   -c: Output in CSV format

📁 ${GREEN}all-features-usage.sh${RESET} [-c]
   Shows all features used in published pages, templates and how many times they are used
   -c: Output in CSV format

🔍 ${GREEN}find-pages-by-feature-name.sh${RESET} -n <feature_name> [-c]
   Find all pages using a specific feature
   -n: Feature name (required, min 2 characters)
   -c: Output in CSV format

📁 ${GREEN}all-content-sources-usage.sh${RESET} [-c]
   Shows content sources usage across features
   -c: Output in CSV format

🔍 ${GREEN}find-features-by-content-source.sh${RESET} -n <content_source> [-c]
   Find all features using a specific content source name (like match)
   -n: Content source filter (required, min 2 characters)
   -c: Output in CSV format

📁 ${GREEN}all-content-sources-resolvers.sh${RESET} [-c]
   Shows content sources usage across resolvers
   -c: Output in CSV format

🔍 ${GREEN}find-resolvers-by-content-source.sh${RESET} -n <content_source> [-c]
   Find all resolvers using a specific content source name (exact match)
   -n: Content source name (required, min 2 characters)
   -c: Output in CSV format

📁 ${GREEN}all-page-urls.sh${RESET} [-c]
   Shows all published pages with their URIs
   -c: Output in CSV format

🔍 ${GREEN}find-pages-by-uri.sh${RESET} -u <uri_filter> [-c]
   Find all pages with a specific URI
   -u: URI filter (required, min 2 characters)
   -c: Output in CSV format

📦 ${GREEN}view-page-and-template.sh${RESET} [-c]
   Select all from view_page_and_template
   -c: Output in CSV format

📦 ${GREEN}view-rendering.sh${RESET} [-c]
   Select all from view_rendering
   -c: Output in CSV format

📦 ${GREEN}view-resolver.sh${RESET} [-c]
   Select all from view_resolver
   -c: Output in CSV format
"
