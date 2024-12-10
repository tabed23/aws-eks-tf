output "release_status" {
  description = "The status of the Helm release"
  value       = helm_release.app.status
}
