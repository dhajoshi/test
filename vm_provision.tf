data "google_compute_network" "default" {
  name = "default"
}
resource "google_compute_instance" "vm_instance" {
  name         = "my-instance"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = data.google_compute_network.default.name
    access_config {
    }
  }
}
check "check_vm_status" {
  data "google_compute_instance" "vm_instance" {
    name = google_compute_instance.vm_instance.name
  }
  assert {
    condition = data.google_compute_instance.vm_instance.current_status == "RUNNING"
    error_message = format("Provisioned VMs should be in a RUNNING status, instead the VM `%s` has status: %s",
      data.google_compute_instance.vm_instance.name,
      data.google_compute_instance.vm_instance.current_status
    )
  }
}
