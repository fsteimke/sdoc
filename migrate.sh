#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CATALOG=$(realpath $XSLTNG/catalog.xml)
PIPELINE=$(realpath migration/xsltng-migration.xpl)

if [[ -f src/*xml ]]; then
    rm src/*.xml
fi
if [[ -f src/media/* ]]; then
    rm src/media/*
fi
if [[ -f src/pdf/* ]]; then
    rm pdf/*
fi

java -jar $CALABASH run --catalog:$CATALOG $PIPELINE
