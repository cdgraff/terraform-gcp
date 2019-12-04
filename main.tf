variable "docker_declaration" {
  # Change the image: string to match the docker image you want to use
  default = "spec:\n  containers:\n    - name: test-docker\n      image: 'ariv3ra/python-cicd-workshop'\n      stdin: false\n      tty: false\n  restartPolicy: Always\n"
}

variable "boot_image_name" {
  default = "projects/cos-cloud/global/images/cos-stable-69-10895-62-0"
}

data "google_compute_network" "default" {
  name = "default"
}

# Specify the provider
provider "google" {
  project = "streamer-box-mediainbox-dev"
  region = "us-central1"
}

resource "google_compute_instance" "default" {
  name = "default"
  machine_type = "g1-small"
  zone = "us-central1-f"
  tags =[
      "name","default"
  ]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.boot_image_name
      type = "pd-standard"
    }
  }

  metadata = {
    gce-container-declaration = var.docker_declaration
  }

  labels = {
    container-vm = "cos-stable-69-10895-62-0"
  }

  network_interface {
    network       = "default"
  }
}

resource "google_storage_bucket" "image-store" {
  name     = "mediainbox-store-bucket"
  location = "US"
}

resource "google_bigtable_instance" "development-instance" {
  name = "tf-instance"
  instance_type = "DEVELOPMENT"

  cluster {
    cluster_id   = "tf-instance-cluster"
    zone         = "us-central1-f"
    storage_type = "SSD"
  }
}
