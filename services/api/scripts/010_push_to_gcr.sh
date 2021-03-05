#!/usr/bin/env bash

# Extract project
GCP_PROJECT=$(gcloud config get-value project)

# Build and tag image
docker build . -t eu.gcr.io/$GCP_PROJECT/speech-api:v1.0.2

# Submit build
docker push eu.gcr.io/$GCP_PROJECT/speech-api:v1.0.2
