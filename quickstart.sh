#!/bin/bash

# References: 
# - https://cloud.google.com/sdk/gcloud/reference/beta/resource-manager


if [[ $OSTYPE == "linux-gnu" && $CLOUD_SHELL == true ]]; then
    echo "********* Welcome to the Bare Metal Setup***************"
    echo "⚡️ Creating New Terraform Service Account."
    export PROJECT_ID=$(gcloud config get-value project)
    export BASE_DIR=${BASE_DIR:="${PWD}"}
    export WORK_DIR=${WORK_DIR:="${BASE_DIR}/workdir"}
    export ZONE=us-central1-a
    export TFSERVICE_ACCT="${PROJECT_ID}-tf-service"
    export PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")
    export COMPENGSERVICE_ACCT="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
    echo "WORK_DIR set to $WORK_DIR"
    echo "PROJECT_ID set to $PROJECT_ID"
    gcloud config set project $PROJECT_ID

#enable the compute engine api
gcloud services enable compute

#create a new terraform service account 
gcloud iam service-accounts create $TFSERVICE_ACCT --description="Auto-created Terraform Service Account" --display-name="Terraform Service Account"

# add proper permissions to TF service account
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$TFSERVICE_ACCT@$PROJECT_ID.iam.gserviceaccount.com"     --role="roles/editor"
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$TFSERVICE_ACCT@$PROJECT_ID.iam.gserviceaccount.com"     --role="roles/iam.securityAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$TFSERVICE_ACCT@$PROJECT_ID.iam.gserviceaccount.com"     --role="roles/iam.serviceAccountAdmin"

#add permissions to the default created compute engine account
#assume default compute service account was created and uses the standard <project number>-compute@devleoper.gserviceaccount.com
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$COMPENGSERVICE_ACCT"     --role="roles/iam.serviceAccountAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$COMPENGSERVICE_ACCT"     --role="roles/compute.instanceAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$COMPENGSERVICE_ACCT"     --role="roles/compute.viewer"
gcloud projects add-iam-policy-binding $PROJECT_ID    --member="serviceAccount:$COMPENGSERVICE_ACCT"     --role="roles/iam.serviceAccountUser"



else
    echo "This has only been tested in GCP Cloud Shell.  Only Linux "debian" is supported"
fi

