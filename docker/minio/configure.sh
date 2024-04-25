#!/usr/bin/env bash

docker-compose run --rm --entrypoint /root/.mc/initialize.sh minio-client
