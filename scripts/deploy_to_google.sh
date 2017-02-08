#!/bin/bash

set -e

GOOGLE_CONTAINER_NAME=gcr.io/steady-computer-156807/flashlight-staging
KUBERNETES_APP_NAME=flashlight-staging
BUCKET_NAME=gs://flashlights-staging
UPLOAD_FILE_NAME=$BUCKET_NAME/datefile
DEFAULT_ZONE=us-central1-a

codeship_google authenticate

# Set the default zone to use
echo "Setting default timezone $DEFAULT_ZONE"
gcloud config set compute/zone $DEFAULT_ZONE

echo "Starting Cluster on GCE for $KUBERNETES_APP_NAME"
gcloud container clusters create $KUBERNETES_APP_NAME \
    --num-nodes 1 \
    --machine-type g1-small

echo "Deploying image on GCE"
kubectl run $KUBERNETES_APP_NAME --image=$GOOGLE_CONTAINER_NAME --port=8080

echo "Exposing a port on GCE"
kubectl expose rc $KUBERNETES_APP_NAME

echo "Waiting for services to boot"

echo "Listing services on GCE"
kubectl get services $KUBERNETES_APP_NAME

echo "Removing service $KUBERNETES_APP_NAME"
kubectl delete services $KUBERNETES_APP_NAME

echo "Waiting After Remove"

echo "Stopping port forwarding for $KUBERNETES_APP_NAME"
kubectl stop rc $KUBERNETES_APP_NAME

echo "Stopping Container Cluster for $KUBERNETES_APP_NAME"
gcloud container clusters delete $KUBERNETES_APP_NAME -q

echo "Remove an existing bucket if it exists"
gsutil rb $BUCKET_NAME | true

echo "Creating a bucket on Google Cloud Storage"
gsutil mb $BUCKET_NAME

echo "Create a file to upload to Google Cloud Storage"
date > datefile
echo "Upload file to Google Cloud Storage"
gsutil cp ./datefile $BUCKET_NAME

echo "Download file from Google Cloud Storage for diff"
gsutil cp $UPLOAD_FILE_NAME ./datefile_downloaded

echo "Removing file from Google Cloud Storage"
gsutil rm $UPLOAD_FILE_NAME

echo "Removing Bucket on Google Cloud Storage"
gsutil rb $BUCKET_NAME

echo "Generating diff from local file and downloaded file"
diff datefile datefile_downloaded

echo "TESTING INTERACTION WITH GOOGLE COMPUTE ENGINE"

echo "Starting an Instance in Google Compute Engine"
gcloud compute instances create testmachine --image "debian-8-jessie-v20170124" --image-project "debian-cloud"

echo "Stopping an Instance in Google Compute Engine"
gcloud compute instances delete testmachine -q