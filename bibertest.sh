#!/bin/sh

/opt/biber --version

/opt/biber --validate-control test.bcf

/opt/biber --convert-control test.bcf
