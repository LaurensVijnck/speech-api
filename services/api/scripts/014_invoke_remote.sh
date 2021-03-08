#!/usr/bin/env bash

GATEWAY=https://speech-api-v1-d5bblst7.ew.gateway.dev # Make sure to align with API gateway URL
AUDIENCE=speech-api # Make sure to align with audience defined in `speech-api.yaml`

# 1. Curl endpoint using project API token

# Note: API keys can be created under 'APIs & Services' -> 'Credentials' -> 'Create credential' -> 'API key' (paste the token in the TOKEN variable below)
TOKEN=PASTE_HERE
curl ${GATEWAY}/hello?key=${TOKEN}

# 2. Curl endpoint using project API token

# Note: Create SA key credentials for the service account as referenced in the 'google_service_account' section of the `speech-api.yaml`
API_CLIENT_GATEWAY_AUTH_SA_PATH=/Users/lvijnck/Desktop/speech-api-creds/sa-client.json
API_CLIENT_GATEWAY_AUTH_SA_EMAIL=sa-gateway-client-dev@dev-lvi.iam.gserviceaccount.com

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
