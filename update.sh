#!/bin/bash

VERSION=$1
SHA=$2

eval "cat <<EOF
$(<comply-fork.rb.template)
EOF
" > comply-fork.rb

git add comply-fork.rb
git commit -m "updated to version $VERSION"
git push
