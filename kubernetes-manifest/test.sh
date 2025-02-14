#!/bin/sh
nix-instantiate --eval --json --strict --argstr manifestsJson "$(yq ea -o=json '[.]' "$(dirname "$0")/test/driver.yml")" | \
jq -rc '.' | \
yq -P > "$(dirname "$0")/test/driver-modified.yml"