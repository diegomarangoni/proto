#!/bin/bash

set -e
cd "$(dirname ${0})/.."

buf check lint
buf check breaking --against-input .git#branch=master

tmpDir=$(mktemp -d)
goProject=$1
goModules="diegomarangoni.dev/go"

if [ ! -d "$1" ]; then
    echo "Invalid Go project root. eg.: $0 path/to/go/project"
    exit 1
fi

if ! grep -q "module $goModules" "$1/go.mod"; then
    echo "Path does not look like '$goModules' project"
    exit 1
fi

buf generate --output $tmpDir

cp -R $tmpDir/go/$goModules/* $goProject/
rm -rf $tmpDir

echo "Go go go :)"
exit 0
