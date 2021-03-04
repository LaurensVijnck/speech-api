GCP_PROJECT=$(gcloud config get-value project)
GCP_REGION="europe-west1"

gcloud run deploy speech-api \
    --image eu.gcr.io/$GCP_PROJECT/speech-api:v1.0.0 \
    --region $GCP_REGION \
    --allow-unauthenticated \
    --platform managed