#! /bin/bash

curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b ./bin

export PATH="./bin/:$PATH"