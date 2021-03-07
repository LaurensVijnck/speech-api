#!/usr/bin/env bash

# Extract project
PROJECT_ID=$(gcloud config get-value project)
BACKEND_SA_EMAIL=lvijnck@geometric-ocean-284614.iam.gserviceaccount.com

gcloud api-gateway api-configs create speech-api \
  --api=speech-api --openapi-spec=speech-api.yaml \
  --project=$PROJECT_ID --backend-auth-service-account=${BACKEND_SA_EMAIL}