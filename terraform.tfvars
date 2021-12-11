project_id                    = "bmterra-1"
region                        = "us-central1"
zone                          = "us-central1-a"
credentials_file              = "/home/admin_/bmterra/bmterra-1-4d778a025835.json"
abm_cluster_id                = "train-cluster"
anthos_service_account_name   = "baremetal-gcr"
resources_path                = "./resources"
machine_type                  = "n1-standard-8"
network                       = "central-bare-1"
subnetwork                    = "barenet-01"
instance_count                = {
                                  "controlplane" : 3
                                  "worker" : 2
                                }
#gpu                          = {
#                                 count = 1,
#                                 type = "nvidia-tesla-k80"
#                               }
