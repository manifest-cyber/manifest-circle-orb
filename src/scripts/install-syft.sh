#! /bin/bash

curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | bash -s -- -b /usr/local/bin \
        export PATH="/usr/local/bin/:$PATH"