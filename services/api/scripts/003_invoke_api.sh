#!/usr/bin/env bash

# Form based call
curl -X POST \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  --form speech_file=@"./assets/test_2.wav" \
  --form language_code="en-US" \
  'http://0.0.0.0:8080/v1/speech'