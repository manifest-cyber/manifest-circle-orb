#!/bin/bash

function update_spdx_sbom {
    local filepath=$1
    local name=$2
    local version=$3

    currentdate=$(date "+%Y%m%d%H%M%S")
    shortsha=$(git rev-parse --short "$CIRCLE_SHA1")

    if [ -z "$name" ]; then
        name="$CIRCLE_PROJECT_REPONAME"
    else
        name="$name"
    fi

    if [ -z "$version" ]; then
        version="${CIRCLE_TAG:-v0.0.0-$currentdate-$shortsha}"
    else
        version="$version"
    fi

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
    local tmpname=$2
    local tmpversion=$3
    local name=""
    local version=""
    local existingName=""
    local existingVersion=""

    currentdate=$(date "+%Y%m%d%H%M%S")
    shortsha=$(git rev-parse --short "$CIRCLE_SHA1")

    # Read the input file and parse the JSON
    input=$(cat "$filepath")

    existingName=$(echo "$input" | jq -r '.metadata.component.name')
    existingVersion=$(echo "$input" | jq -r '.metadata.component.version')

    if [ -z "$tmpname" ]; then
        name="$CIRCLE_PROJECT_REPONAME"
    else
        name="$tmpname"
    fi

    if [ -z "$tmpversion" ]; then
        version="${CIRCLE_TAG:-v0.0.0-$currentdate-$shortsha}"
    else
        version="$tmpversion"
    fi

    json=$(echo "$input" | jq -r '.metadata.component')
    if [ ! -z "$tmpname" ] || [ -d "$existingName" ] || [ "$existingName" == "null" ]; then

        # Add the name to the "name" field
        json=$(echo "$json" | jq ".name = \"$name\"")
    else
        echo "using existing SBOM values for name: $existingName"
    fi

    if [ ! -z "$tmpversion" ] || [ "$existingVersion" == "null" ]; then

        # Add the version to the "version" field
        json=$(echo "$json" | jq ".version = \"$version\"")
    else
        echo "using existing SBOM values for version: $existingVersion"
    fi

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

curl https://gist.githubusercontent.com/manifestori/4a6c62617e05fb054a1410a16ea2b29b/raw/43686f969cf4b7a4752cd8992bfd38fbef2e5e48/syft.yaml >syft.yaml
filename="$SBOM_FILENAME"
source="$SBOM_SOURCE"
output="$SBOM_OUTPUT"
name="$SBOM_NAME"
version="$SBOM_VERSION"

./bin/syft -v "$source" --config=syft.yaml --output="$output" --file="$filename"

update_sbom "$filename" "$name" "$version" "$output"

