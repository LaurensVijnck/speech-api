#!/usr/bin/env bash

TOKEN=AIzaSyCat_KuI5oSWLMwAFR4_ebJ1qmra_0Z_s0

# Form based call
curl -X POST \
  --header "Authorization: Bearer ${TOKEN}" \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  -F speech_file=@"/Users/lvijnck/Desktop/speech-api/services/api/assets/test.wav" \
  -F language_code="en-US" \
  'https://speech-api-2xxh104v.ew.gateway.dev/v1/speech' -k
