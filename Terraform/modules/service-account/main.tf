resource "google_service_account" "service-account" {
  account_id   = var.service_account
  display_name = var.service_account
}

resource "google_project_iam_binding" "cluster-role-binding" {
  project = var.project_name
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.service-account.email}"
  ]
}