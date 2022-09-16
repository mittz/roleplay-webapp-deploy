resource "random_id" "tasks_queue_name_suffix" {
  byte_length = 4
}

resource "google_cloud_tasks_queue" "queue" {
  name = "queue-${random_id.tasks_queue_name_suffix.hex}"
  location = "us-central1"

  retry_config {
    max_attempts = 1
  }
}