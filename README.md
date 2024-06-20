Example code is provided by a community of developers. They are intended to help you get started more quickly, but are not guaranteed to cover all scenarios nor are they supported by Arc XP.

> These examples are licensed under the [MIT license](https://mit-license.org/): THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Reiterated from license above, all code in this example is free to use, and as such, there is NO WARRANTY, SLA or SUPPORT for these examples.

----


## Scripts to analyze pb-data locally

Notes:
- pb-data is a database snapshot of PageBuilder data, taken every 12 hours.


## Requirements

- Mongodb Tools: https://www.mongodb.com/docs/database-tools/installation/installation-macos/
- Duckdb CLI https://duckdb.org/docs/api/cli/overview.html#installation


## How to use

1. Make sure you install the dependencies that `bsondump` and `duckdb` commands are present in your current bash session.
2. First, download the pb-data from Arc XP Admin > PageBuilder > Developer Tools > PB Data screen, to your local computer.
3. Unzip the downloaded tar file, and rename the folder as `pb-data` and place it in this projects root folder.
4. Run `sh _prepare.sh` command to create temp database file (duckdb file) that contains the simplified views that is used in different shell scripts. These views are not copying the actual data, they are just views referring to the actual JSON files converted from mongodb bson files.
5. Run any of the shell script. These scripts are plain and simple, you can read the code to understand what the parameters, or add `-h` argument to the scripts to see help text for each one of them (i.e: `sh find-pages-by-feature-name.sh -h`)


## Video Tutorial

[![Video Tutorial](https://img.youtube.com/vi/Sy3FjQv73VM/0.jpg)](https://www.youtube.com/watch?v=Sy3FjQv73VM)

The video and tutorial can be found in "[How to check feature/content-source usage using pb-data analysis scripts](https://docs.arcxp.com/alc/en/how-to-check-feature-content-source-usage-using-pb-data-analysis-scripts?id=kb_article_view&sys_kb_id=b5ee6257c3f2ca50a046930a05013129#mcetoc_1i0qpofi99f)" ALC documentation.


## Scripts

#### `all-features-usage`
produces list of all features used in your pb-data (not bundle), in published pages and templates along with how many pages they are used in and the number of times (instances) they are used in these pages.

#### `find-pages-by-feature-name`
requires `-n` parameter with a feature name that will print list of pages and templates which uses this feature.

You can open pagebuilder editor with the following url template with the page or template id in the query string: `https://YOURORG.arcpublishing.com/pagebuilder/editor/curate?p=PAGEID`

#### `all-content-sources-usage`
List of all content sources, from both global content source configurations (from resolvers) and feature configurations.
This script does NOT have csv export option.

#### `all-page-urls`
Lists all published pages with their URIs.
Note: Only pages listed in this scripts output, templates are powered by dynamic URL patterns from resolvers which are not included in this script's output.

### `find-pages-by-uri`
List all pages with URI containing the provided filter.

### `describe-page-or-template`
Describes contents of a page or template by it's id provided by `-i` argument.
This script shows meta data of this page (uri, title), list of features, sorted by how many times used in the page/template, and the content sources configured from features.
