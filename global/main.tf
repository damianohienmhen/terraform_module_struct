# create network to run cluster instances

# create Kubernetes cluster, VPC, node-pools, NAT, firewall & subnet
module "network" {
  source             = "../modules/network"
}

# create service-accounts
module "service_account" {
  source       = "../modules/service-account"
}


