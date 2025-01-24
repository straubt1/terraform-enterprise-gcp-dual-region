# module "primary-tfe" {
#   source = "./modules/tfe"

#   project_id       = var.project_id
#   primary_region   = var.primary_region
#   secondary_region = var.secondary_region
#   namespace        = var.namespace
#   common_labels    = var.common_labels
#   ssh_public_key   = tls_private_key.keypair.public_key_openssh
#   vpc_self_link    = module.primary-region.vpc_self_link
#   subnet_self_link = module.primary-region.subnet_self_link

#   postgres_settings = {
#     deletion_protection             = false
#     insights_query_insights_enabled = true # Help see the queries
#     point_in_time_recovery_enabled  = true
#   }
#   gke_settings = {
#     cluster_is_private            = false
#     control_plane_authorized_cidr = var.cidr_allow_ingress[0]
#   }
#   tfe_secrets = {
#     license      = file(var.tfe_license_file)
#     tls_cert_b64 = "" # filebase64("${path.cwd}/keys/tls_fullchain.pem")
#     tls_key_b64  = "" #filebase64("${path.cwd}/keys/tls_privkey.pem")
#   }
# }
