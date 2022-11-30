#! /bin/sh

tmp=$2
filename=${tmp:-cdx.json}
syft "$1" --config=syft.yaml --file="$filename"