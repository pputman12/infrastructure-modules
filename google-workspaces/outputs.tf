output "workspace-users" {
  value     = googleworkspace_user.users
  sensitive = true
}

output "workspace-admin-roles" {
  value     = googleworkspace_role_assignment.role_assignment
  sensitive = true
}


output "workspace_users_data" {
  value = data.googleworkspace_users.workspace-users.users
}

