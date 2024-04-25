#!/bin/bash

set -e

# Remove a potentially pre-existing server pid for rails
rm -f /srv/app/tmp/pids/server.pid

bundle check || bundle install

bundle binstubs --all --path="$BUNDLE_BIN"

# Then exec the container's main process
exec "$@"
