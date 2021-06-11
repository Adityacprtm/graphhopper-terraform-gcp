provider "google" {
  credentials = "<service-account.json>"
  project     = "<project_id>"
  region      = var.region
}

resource "google_compute_instance_template" "graphhopper" {
  name_prefix = "graphhopper-template-"
  description = "This template is used to create graphhopper service instance"

  tags = ["<network-tags>"]

  labels = {
    "env"     = "prd"
    "service" = var.base_name
  }

  machine_type   = "e2-standard-4"
  can_ip_forward = false

  disk {
    source_image = data.google_compute_image.latest_graphhopper_image.self_link
    auto_delete  = true
    boot         = true
    disk_size_gb = 25
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.default_subnetwork.self_link
  }

  metadata_startup_script = var.graphhopper_startup_script

  lifecycle {
    create_before_destroy = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

resource "google_compute_region_instance_group_manager" "graphhopper_group" {
  name = "graphhopper-group"

  base_instance_name = var.base_name
  region             = var.region

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  version {
    name              = var.base_name
    instance_template = google_compute_instance_template.graphhopper.self_link
  }

  update_policy {
    type                         = "PROACTIVE"
    replacement_method           = "SUBSTITUTE"
    minimal_action               = "REPLACE"
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = 3
    max_unavailable_fixed        = 0
    min_ready_sec                = 30
  }
}

data "google_compute_image" "latest_graphhopper_image" {
  family  = "graphhopper" // same on packer
  project = "<project_id>"
}

data "google_compute_subnetwork" "default_subnetwork" {
  name   = "default"
  region = var.region
}
