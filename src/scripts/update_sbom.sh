#!/bin/bash

function update_spdx_sbom {
    local filepath=$1
    local name=$2
    local version=$3

    #
    if (! jq '.relationships[] | select(.relationshipType == "DESCRIBES")' "$filepath") >/dev/null 2>&1; then
        jq --arg name "$name-$version" \
            '.name = $name' \
            "$filepath" >"$filepath".tmp && mv "$filepath".tmp "$filepath"

        jq --arg id "SPDXRef-DOCUMENT" --arg rel "SPDXRef-Package-$name-$version" \
            '.relationships += [{"relationshipType": "DESCRIBES", "spdxElementId": $id, "relatedSpdxElement": $rel}]' \
            "$filepath" >"$filepath".tmp && mv "$filepath".tmp "$filepath"

        jq --arg id "SPDXRef-Package-$name-$version" --arg name "$name" --arg version "$version" \
            '.packages += [{"SPDXID": $id, "name": $name, "versionInfo": $version}]' \
            "$filepath" >"$filepath".tmp && mv "$filepath".tmp "$filepath"
    fi
}

function update_cyclonedx_sbom {
    local filepath=$1
    local name=$2
    local version=$3

    # Read the input file and parse the JSON
    input=$(cat "$filepath")
    json=$(echo "$input" | jq -r '.metadata.component')

    # Add the name to the "name" field
    json=$(echo "$json" | jq ".name = \"$name\"")

    # Add the version to the "version" field
    json=$(echo "$json" | jq ".version = \"$version\"")

    # Update the input JSON with the updated version
    input=$(echo "$input" | jq '.metadata.component = $json' --argjson json "$json")

    # Output the updated JSON to a file
    echo "$input" >"$filepath"
}

function update_sbom {
    if [ $# -ne 4 ]; then
        echo "Usage: $0 <json file> <version> <name> <type: spdx-json | cyclonedx-json>"
        exit 1
    fi

    if [ ! -f "$1" ]; then
        echo "Error: input file does not exist"
        exit 1
    fi

    local filepath=$1
    local name=$2
    local version=$3
    local type=$4

    if [ "$type" == "spdx-json" ]; then
        update_spdx_sbom "$filepath" "$name" "$version"
    elif [ "$type" == "cyclonedx-json" ]; then
        update_cyclonedx_sbom "$filepath" "$name" "$version"
    else
        echo "Error: invalid SBOM type"
    fi
}