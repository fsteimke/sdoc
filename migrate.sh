#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SOURCE=$(realpath doc-sle-15SP7/xml/MAIN.SLEDS.xml)
CATALOG=$(realpath $XSLTNG/catalog.xml)
PIPELINE=$(realpath migration/xsltng-migration.xpl)
CALABASH=$(realpath $XSLTNG/xmlcalabash/xmlcalabash-app-3*.jar)
PROJECT_DIR=$(pwd)

if [[ $(ls -A "src/*xml" 2>/dev/null) ]]; then
    echo "remove src"
    rm src/*.xml
fi
if [[ $(ls src/media/* 2>/dev/null) ]]; then
    echo "remove media"
    rm src/media/*
fi
if [[ $(ls pdf/* 2>/dev/null) ]]; then
    echo "remove pdf"
    rm pdf/*
fi

java -jar $CALABASH run --input:source=$SOURCE --catalog:$CATALOG $PIPELINE \
      project-dir=$PROJECT_DIR
