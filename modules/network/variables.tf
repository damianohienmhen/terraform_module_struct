variable "clust_name" {
  description = "The name of the primary cluster"
   default     = "primary"
}

variable "zone_1" {
  description = "Zonal location of regional cluster deployment"
  default     = "us-central1-a"
}

variable "vpc" {
  description = "The type of networking mode to be implemented"
   default     = "VPC_NATIVE"
}

variable "zone_2" {
  description = "Zonal location of optional regional cluster deployment"
  default     = "us-central1-b"
}

variable "proj_id" {
  description = "The name of the project"
  default     = "third-project-399423"
}

variable "master_cidr" {
  description = "Master IPV4 CIDR Range. Need it for Control Plane provisioning"
   default     = "172.16.0.0/28"
}

variable "master_authorized" {
  description = "Master IPV4 CIDR Range. Need it for Control Plane provisioning"
   default     = "10.0.0.0/18"
}


variable "router_name" {
  description = "The name of the router"
   default     = "router"
}

variable "region" {
  description = "Type of region to create resources in"
  default     = "us-central1"
}

variable "subnet_name" {
  description = "The name of the subnetwork"
   default     = "private"
}

variable "cidr_rng" {
  description = "IP CIDR range to provision. Nodes will use network range from this main cidr range"
  default     = "10.0.0.0/18"
}


variable "sec_pod_range" {
  description = "Secondary IP range of node clusters"
   default     = "k8s-pod-range"
}

variable "ip_sec_pod_range" {
  description = "Pods will use network range from secondary cidr range"
  default     = "10.48.0.0/14"
}

variable "sec_serve_range" {
  description = "Secondary IP range of node clusters"
   default     = "k8s-service-range"
}

variable "ip_sec_serve_range" {
  description = "Used to assign IP's for the clusters "
  default     = "10.52.0.0/20"
}

variable "compute_api" {
  description = "URL to access Google compute API's"
  default     = "compute.googleapis.com"
}

variable "container_api" {
  description = "URL to access Google container API's"
  default     = "container.googleapis.com"
}

variable "main" {
  description = "Name of compute network"
  default     = "main"
}

variable "route" {
  description = "Routing mode to use"
  default     = "REGIONAL"
}
#node-pools
variable "machine_type" {
  description = "Type of machine to create"
  default     = "e2-small"
}

variable "node_count" {
  description = "The number of nodes to create in this Node Pool"
  default     = 1
}
#nat definition
variable "nat_name" {
  description = "The name of the router"
   default     = "nat"
}

variable "subnet_list" {
  description = "List of subnetworks to create"
  default     = "LIST_OF_SUBNETWORKS"
}

variable "nat_allocate" {
  description = "IP list to allocate for"
   default     = "MANUAL_ONLY"
}

variable "address_type" {
  description = "The type of address type to provision"
  default     = "EXTERNAL"
}

variable "net_tier" {
  description = "Type of network tier to create"
  default     = "PREMIUM"                                                                                                                             # Container-Optimized OS
}
#firewall definition
variable "firewall_name" {
  description = "The name of the firewall rule"
    default     = "allow-ssh"
}


variable "network" {
  description = "The network this firewall rule applies to"
  default     = "default"
}


variable "protocol" {
  description = "The name of the protocol to allow"
  default     = "tcp"
}

variable "ports" {
  description = "A list of ports and/or port ranges to allow"
  default     =  ["22","80","8080"]
}

variable "source_ranges" {
  description = "A list of source CIDR ranges that this firewall applies to"
  default     = ["0.0.0.0/0"]
}
