#!/usr/bin/env bash

curl -X POST \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  -F speech_file=@"/Users/lvijnck/Desktop/speech-api/services/api/assets/piano2.wav" 'http://0.0.0.0:8080/v1/speech' -k