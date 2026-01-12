output "database_credentials_note" {
  description = "Note: The database password is sensitive and hidden."
  value       = "The database user 'admin' was created."
  # Do NOT include the password here, use a non-sensitive note.
}

output "database_password" {
  description = "The database password. This output is marked sensitive and will be hidden."
  value       = random_password.adb_password.result
  sensitive   = true # CRITICAL: Hides the value from stdout
}