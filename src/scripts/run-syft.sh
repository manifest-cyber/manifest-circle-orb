#! /bin/bash

filename="${2:-cdx.json}"
syft "$1" --config=syft.yaml --file="$filename"