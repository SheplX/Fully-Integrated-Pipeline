resource "google_service_account" "service-account" {
  account_id   = "${lower(var.project_name)}-service-account"
  display_name = "${lower(var.project_name)}-service-account"
}

resource "google_project_iam_binding" "cluster-role-binding" {
  depends_on = [google_service_account.service-account]
  project    = lower(var.project_name)
  role       = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.service-account.email}"
  ]
}
