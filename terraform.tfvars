project_id                    = "bm-terra-6"
region                        = "us-central1"
zone                          = "us-central1-a"
credentials_file              = "bm-terra-6-tf-service.json"
abm_cluster_id                = "clusterbtb"
anthos_service_account_name   = "baremetal-gcr"
resources_path                = "./resources"
machine_type                  = "n1-standard-8"
network                       = "bm-vpc-01"
subnetwork                    = "bm-vpc-sub-01"
instance_count                = {
                                  "controlplane" : 3
                                  "worker" : 2
                                }
#gpu                          = {
#                                 count = 1,
#                                 type = "nvidia-tesla-k80"
#                               }
