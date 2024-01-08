# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
#VPC definition

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_compute_network" "main" {
  name                            = "${var.main}"
  routing_mode                    = "${var.route}"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false #allows you to create your own subnets

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

# Kubernetes cluster definition

resource "google_container_cluster" "primary" {
  name                     = "${var.clust_name}"
  location                 = "${var.zone_1}" #budget sensitive to set up a specific zonal cluster
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes" #will add lots of cost with more logs
  monitoring_service       = "monitoring.googleapis.com/kubernetes" #not free either
  networking_mode          = "${var.vpc}"

  # Optional, if you want multi-zonal cluster
  node_locations = [
    "${var.zone_2}" 
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "third-project-399423.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.sec_pod_range}" 
    # services_secondary_range_name = "${var.ip_sec_pod_range}"  
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "${var.master_cidr}" 
  }
}

# router definition

resource "google_compute_router" "router" {
  name    = "${var.router_name}"
  region  = "${var.region}"
  network = google_compute_network.main.id
}

#subnetwork definition

resource "google_compute_subnetwork" "private" {
  name                     = "${var.subnet_name}"
  ip_cidr_range            = "${var.cidr_rng}" 
  region                   = "${var.region}" 
  network                  = google_compute_network.main.id
  private_ip_google_access = true
  

  secondary_ip_range {
    range_name    = "${var.sec_pod_range}" 
    ip_cidr_range = "${var.ip_sec_pod_range}"  
  }
  secondary_ip_range {
    range_name    = "${var.sec_serve_range}" 
    ip_cidr_range = "${var.ip_sec_serve_range}"  
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}


resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = "${var.node_count}"
  
   management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "${var.machine_type}"
    
    labels = {
      role = "general"
    }
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


#node pools definition
resource "google_container_node_pool" "spot" {
  name       = "spot"
  cluster    = google_container_cluster.primary.id
  
   management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "${var.machine_type}"
    
    labels = {
      team = "devops"
    }
    
    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }
    
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}
#nat definition
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat

resource "google_compute_router_nat" "nat" {
  name   = "${var.nat_name}"
  router = google_compute_router.router.name
  region = "${var.region}"

  source_subnetwork_ip_ranges_to_nat = "${var.subnet_list}"
  nat_ip_allocate_option             = "${var.nat_allocate}"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "nat" {
  name         = "${var.nat_name}"
  address_type = "${var.address_type}"
  network_tier = "${var.net_tier}"

  depends_on = [google_project_service.compute]
}

#firewall definition

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_firewall" "default" {
  name        = "${var.firewall_name}"
  network     = google_compute_network.main.name

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges = "${var.source_ranges}"
}