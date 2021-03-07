#!/usr/bin/env bash

GATEWAY=https://speech-api-v1-2xxh104v.ew.gateway.dev
AUDIENCE=https://cr-speech-api-dev-5ledmsck3a-ew.a.run.app

## 1. Curl endpoint using project API token
TOKEN=AIzaSyDIFSteFkJr_f0hc074T_9FDIC_ZOLctOk
curl ${GATEWAY}/hello?key=${TOKEN}

# 2. Curl endpoint using project API token

# Obtain bearer token for service account
BEARER_TOKEN=$(python jwt_token_gen.py \
    --file=/Users/lvijnck/Desktop/geometric-ocean-284614-3035aab8c2f8.json \
    --audiences=${AUDIENCE} \
    --issuer=sa-cr-speech-api-dev@geometric-ocean-284614.iam.gserviceaccount.com)

curl -X POST \
  --header "authorization: Bearer ${BEARER_TOKEN}" \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  --form speech_file=@"/Users/lvijnck/Desktop/speech-api/services/api/assets/test_2.wav" \
  --form language_code="en-US" \
  ${GATEWAY}/v1/speech
