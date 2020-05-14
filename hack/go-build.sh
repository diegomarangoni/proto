#!/bin/bash

set -e

cd "$(dirname ${0})/.."

if [[ -z "$1" ]]; then
    echo "Missing Go project root. eg.: $0 path/to/diegomarangoni/gomonorepo"
    exit 1
fi

if [[ -z $(sed -n '/^module github.com\/diegomarangoni\/gomonorepo/p;q' $1/go.mod) ]]; then
    echo 'Path does not look like "diegomarangoni/gomonorepo" project'
    exit 1
fi

PROJECT_ROOT=$1
OUTPUT_PATH=$(mktemp -d)
PROTOC_ARGS=""

PROTOC_ARGS+=" -I src"
#PROTOC_ARGS+=" -I third_party/googleapis"

find src/ -name "*.proto" -type f -exec protoc $PROTOC_ARGS {} --go_out=plugins=grpc:$OUTPUT_PATH \;

mkdir -p $PROJECT_ROOT/pkg/pb/
rm -rf $PROJECT_ROOT/pkg/pb/*

cp -R $OUTPUT_PATH/github.com/diegomarangoni/gomonorepo/pkg/pb/* $PROJECT_ROOT/pkg/pb/

rm -rf $OUTPUT_PATH

echo "Go go go :)"