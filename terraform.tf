provider "google" {
  project = "enuygun-454608"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "gke-k8s-cluster"
  location = "us-central1"
  deletion_protection = false
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"
}

resource "google_container_node_pool" "main_pool" {
  name       = "main-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = "e2-medium"
    tags         = ["main-pool"]
    disk_size_gb = 25
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_container_node_pool" "app_pool" {
  name       = "application-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = "e2-medium"
    tags         = ["app-pool"]
    disk_size_gb = 25
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "node_pools" {
  value = [google_container_node_pool.main_pool.name, google_container_node_pool.app_pool.name]
}
