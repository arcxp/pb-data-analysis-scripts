#!/bin/bash

echo "Available scripts and their usage:

1. all-chains-usage.sh [-c]
   Shows all chains used in published pages, templates and how many times they are used
   -c: Output in CSV format

2. all-features-usage.sh [-c]
   Shows all features used in published pages, templates and how many times they are used
   -c: Output in CSV format

3. find-pages-by-chain-name.sh -n <chain_name> [-c]
   Find all pages using a specific chain
   -n: Chain name (required, min 2 characters)
   -c: Output in CSV format

4. find-pages-by-feature-name.sh -n <feature_name> [-c]
   Find all pages using a specific feature
   -n: Feature name (required, min 2 characters)
   -c: Output in CSV format

5. all-content-sources-usage.sh
   Shows global content sources usage across resolvers and features

6. all-page-urls.sh [-c]
   Shows all published pages with their URIs
   -c: Output in CSV format

7. find-pages-by-uri.sh -u <uri_filter> [-c]
   Find all pages with a specific URI
   -u: URI filter (required, min 2 characters)
   -c: Output in CSV format

8. describe-page-or-template.sh -i <page_or_template_id> [-c]
   Describe a specific page or template with its chains, features, and content sources
   -i: Page or Template ID (required, min 2 characters)
   -c: Output in CSV format
"
