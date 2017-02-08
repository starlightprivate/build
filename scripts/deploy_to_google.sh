#!/bin/bash

set -e

GOOGLE_CONTAINER_NAME=gcr.io/steady-computer-156807/flashlight-staging
KUBERNETES_APP_NAME=flashlight-staging
BUCKET_NAME=gs://flashlights-staging
UPLOAD_FILE_NAME=$BUCKET_NAME/datefile
DEFAULT_ZONE=us-east1-b

codeship_google authenticate

# Set the default zone to use
echo "Setting default timezone $DEFAULT_ZONE"
gcloud config set compute/zone $DEFAULT_ZONE

echo "Connect to clusters"
gcloud container clusters get-credentials flashlight-staging \
    --zone us-east1-b --project steady-computer-156807

echo "Deploying image on GCE"
kubectl run $KUBERNETES_APP_NAME --image=$GOOGLE_CONTAINER_NAME --port=8080

echo "Exposing a port on GCE"
kubectl expose rc $KUBERNETES_APP_NAME

echo "Waiting for services to boot"

echo "Listing services on GCE"
kubectl get services $KUBERNETES_APP_NAME
