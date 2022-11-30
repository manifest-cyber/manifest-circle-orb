#! /bin/bash

sudo curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

export PATH="/usr/local/bin/:$PATH"