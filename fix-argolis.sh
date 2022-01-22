#!/bin/bash
# this is based on some work done for the GKE toolkit script Modify Argolis Policies that block GKE Toolkit deployment
# References: 
# - https://cloud.google.com/sdk/gcloud/reference/beta/resource-manager
# - https://cloud.google.com/compute/docs/images/restricting-image-access#trusted_images

if [[ $OSTYPE == "linux-gnu" && $CLOUD_SHELL == true ]]; then
    echo "********* Welcome to the Argolis opener***************"
    echo "⚡️ Fixing Org Policies and Constaints."
    export PROJECT_ID=$(gcloud config get-value project)
    export BASE_DIR=${BASE_DIR:="${PWD}"}
    export WORK_DIR=${WORK_DIR:="${BASE_DIR}/workdir"}
    export ZONE=us-central1-a
    echo "WORK_DIR set to $WORK_DIR"
    echo "PROJECT_ID set to $PROJECT_ID"
    gcloud config set project $PROJECT_ID


# Disable Policies without Constraints
    gcloud beta resource-manager org-policies disable-enforce compute.requireShieldedVm --project=$PROJECT_ID
    gcloud beta resource-manager org-policies disable-enforce compute.requireOsLogin --project=$PROJECT_ID
    gcloud beta resource-manager org-policies disable-enforce iam.disableServiceAccountKeyCreation --project=$PROJECT_ID
    gcloud beta resource-manager org-policies disable-enforce iam.disableServiceAccountCreation --project=$PROJECT_ID

# now loop and fix policies with  constraints in Argolis 
# Inner Loop - Loop Through Policies with Constraints
declare -a policies=("constraints/compute.trustedImageProjects"
                 "constraints/compute.vmExternalIpAccess"
 "constraints/compute.restrictSharedVpcSubnetworks"
 "constraints/compute.restrictSharedVpcHostProjects" 
 "constraints/compute.restrictVpcPeering"
 "constraints/compute.vmCanIpForward")

for policy in "${policies[@]}"
do
cat <<EOF > new_policy.yaml
constraint: $policy
listPolicy:
 allValues: ALLOW
EOF
    gcloud resource-manager org-policies set-policy new_policy.yaml --project=$PROJECT_ID
done
# End Inner Loop


else
    echo "This has only been tested in GCP Cloud Shell.  Only Linux "debian" is supported"
fi

