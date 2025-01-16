# terraform-enterprise-gcp

## Setup GCP Project

```sh
services_to_enable=("storage-api.googleapis.com" "storage-component.googleapis.com" "storage.googleapis.com" "secretmanager.googleapis.com" "servicenetworking.googleapis.com" "sqladmin.googleapis.com" "logging.googleapis.com" "monitoring.googleapis.com" "oslogin.googleapis.com" "dns.googleapis.com" "cloudresourcemanager.googleapis.com" "compute.googleapis.com" "cloudkms.googleapis.com" "autoscaling.googleapis.com" "iam.googleapis.com" "iamcredentials.googleapis.com" "vpcaccess.googleapis.com" "sts.googleapis.com" "redis.googleapis.com" "networkservices.googleapis.com")

for service in ${services_to_enable[*]}; do
      echo $service
      gcloud services enable $service
done
```

## Bootstrap

module.pre-reqs.google_compute_network.vpc[0]
module.pre-reqs.google_compute_subnetwork.subnet[0]
module.pre-reqs.google_compute_router.router[0]
module.pre-reqs.google_compute_router_nat.nat[0]

module.pre-reqs.data.google_compute_zones.available
module.pre-reqs.google_compute_firewall.bastion_proxy[0]
module.pre-reqs.google_compute_firewall.bastion_ssh[0]
module.pre-reqs.google_compute_firewall.https[0]
module.pre-reqs.google_compute_firewall.lb_health_checks[0]
module.pre-reqs.google_compute_global_address.private_data[0]
module.pre-reqs.google_compute_instance.bastion[0]
module.pre-reqs.google_secret_manager_secret.tfe_database_password[0]
module.pre-reqs.google_secret_manager_secret_version.tfe_database_password[0]
module.pre-reqs.google_service_networking_connection.private_data[0]

## TFE

Create Secrets Manager Secrets:
- PSQL Password
- Redis Password
- Encryption Password
- TFE License File
- TLS Cert
- TLS Key