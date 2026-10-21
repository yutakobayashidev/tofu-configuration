resource "openai_organization_user" "owner" {
  role = "owner"
}

resource "openai_project_user" "owner" {
  project_id = openai_project.default.id
  user_id    = openai_organization_user.owner.id
  role       = "owner"
}
