#!/usr/bin/env bash

# Extract project
PROJECT_ID=$(gcloud config get-value project)
GCP_REGION="europe-west1"

gcloud api-gateway gateways create speech-api \
  --api=speech-api --api-config=speech-api \
  --location=$GCP_REGION --project=$PROJECT_ID