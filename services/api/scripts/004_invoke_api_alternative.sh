#!/usr/bin/env bash

# Alternative approach
curl -X POST \
  --data-binary @"./assets/test.wav" \
  --header "Content-Type: application/octet-stream" \
  "http://0.0.0.0:8080/v2/speech"