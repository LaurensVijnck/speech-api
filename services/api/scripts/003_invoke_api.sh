#!/usr/bin/env bash

# Form based call
curl -X POST \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  -F speech_file=@"/Users/lvijnck/Desktop/speech-api/services/api/assets/test.wav" -F language_code="en-US" 'http://0.0.0.0:8080/v1/speech' -k