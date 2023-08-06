provider "google" {
  project = "wili-394920"
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_container_cluster" "gke" {
  name                = "wili-gke-cluster"
  location            = var.region
  initial_node_count  = 1
  network             = var.vpc_name
  subnetwork          = var.subnet_name
  depends_on          = [ google_compute_subnetwork.subnet, google_compute_network.vpc ] 
}

resource "google_artifact_registry_repository" "gcr" {
  location = var.region
  repository_id = "wili-repository"
  description = "GCR for wili project."
  format = "docker"
}
