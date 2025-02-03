namespace         = "my-tfe"
project_id        = ""
managed_zone_name = ""
domain            = "tfe.company.com"
cert_email        = "certadmin@email.com"

regions = {
  blue  = "us-central1"
  green = "us-west1"
}
subnet_cidrs = {
  blue  = "10.0.1.0/24"
  green = "10.0.2.0/24"
}
common_labels = {
  owner    = "me"
  platform = "tfe"
}
cidr_allow_ingress = [
  "1.2.3.4/32" # My IP Address for access into virtual network
]

tfe_license_file = "./path/to/license.rli"