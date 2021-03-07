#!/usr/bin/env bash

BEARER_TOKEN=$(python jwt_token_gen.py \
    --file=/Users/lvijnck/Desktop/geometric-ocean-284614-d42818ab7892.json \
    --audiences=https://speech-api-5ledmsck3a-ew.a.run.app \
    --issuer=sa-speech-api-dev@geometric-ocean-284614.iam.gserviceaccount.com)

curl -X POST \
  --header "authorization: Bearer ${BEARER_TOKEN}" \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  -F speech_file=@"/Users/lvijnck/Desktop/speech-api/services/api/assets/test.wav" \
  -F language_code="en-US" \
  'https://speech-api-2xxh104v.ew.gateway.dev/v1/speech' -k
