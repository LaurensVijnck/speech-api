#!/usr/bin/env bash

GATEWAY=https://speech-api-v1-2xxh104v.ew.gateway.dev # Make sure to align with API gateway URL
AUDIENCE=speech-api # Make sure to align with audience defined in `speech-api.yaml`

# 1. Curl endpoint using project API token

# Note: API keys can be created under 'APIs & Services' -> 'Credentials' -> 'Create credential' -> 'API key' (paste the token in the TOKEN variable below)
TOKEN=AIzaSyDIFSteFkJr_f0hc074T_9FDIC_ZOLctOk
curl ${GATEWAY}/hello?key=${TOKEN}

# 2. Curl endpoint using project API token

# Note: Create an SA key credentials for the service account as referenced in the 'google_service_account' section of the `speech-api.yaml`
API_CLIENT_GATEWAY_AUTH_SA_PATH=/Users/lvijnck/Desktop/credentials/geometric-ocean-284614-93c7e086b9d0.json
API_CLIENT_GATEWAY_AUTH_SA_EMAIL=sa-gateway-client-dev@geometric-ocean-284614.iam.gserviceaccount.com

# Obtain bearer token for service account

# Note make sure to create/activate a venv with requirements.txt in order to execute the command below
BEARER_TOKEN=$(python jwt_token_gen.py \
    --file=${API_CLIENT_GATEWAY_AUTH_SA_PATH} \
    --audiences=${AUDIENCE} \
    --issuer=${API_CLIENT_GATEWAY_AUTH_SA_EMAIL})

curl -X POST \
  --header "authorization: Bearer ${BEARER_TOKEN}" \
  --header 'Content-Type: multipart/form-data' \
  --header 'Accept: application/json' \
  --form speech_file=@"./assets/test_2.wav" \
  --form language_code="en-US" \
  ${GATEWAY}/v1/speech
