#!/bin/sh

BIBER_BRANCH="${1:-dev}"
BIBER_REPO="${2:-plk/biber}"

wget "https://raw.githubusercontent.com/${BIBER_REPO}/${BIBER_BRANCH}/testfiles/test.bcf"
wget "https://raw.githubusercontent.com/${BIBER_REPO}/${BIBER_BRANCH}/testfiles/test.bib"
/opt/biber --version

/opt/biber --validate-control test.bcf

/opt/biber --convert-control test.bcf
