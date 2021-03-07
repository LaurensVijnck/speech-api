#!/usr/bin/env bash

# Extract project
PROJECT_ID=$(gcloud config get-value project)

# Enable API key support for api
gcloud services enable speech-api-1sz04po2mhkkq.apigateway.geometric-ocean-284614.cloud.goog