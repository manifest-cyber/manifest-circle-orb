#! /bin/bash
syft "$1" --config=syft.yaml --file="$2"