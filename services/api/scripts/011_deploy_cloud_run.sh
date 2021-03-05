#!/usr/bin/env bash

# Extract project
GCP_PROJECT=$(gcloud config get-value project)
GCP_REGION="europe-west1"

gcloud run deploy speech-api \
    --image eu.gcr.io/$GCP_PROJECT/speech-api:v1.0.2 \
    --region $GCP_REGION \
    --allow-unauthenticated \
    --platform managed