#!/usr/bin/env bash

# Run the API and mount credentials into the docker container
docker run \
    -e PORT=8080 \
    -v $GOOGLE_APPLICATION_CREDENTIALS:/tmp/keys/sa.json:ro \
    -e PYTHONUNBUFFERED=TRUE \
    -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/keys/sa.json \
    -p 8080:8080 \
    speech-api