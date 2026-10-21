resource "supabase_settings" "freeschool_search" {
  project_ref     = supabase_project.freeschool_search.id
  api             = jsonencode(jsondecode(file("${path.module}/settings/freeschool_search/api.json")))
  auth            = jsonencode(jsondecode(file("${path.module}/settings/freeschool_search/auth.json")))
  database        = jsonencode(jsondecode(file("${path.module}/settings/freeschool_search/database.json")))
  network         = jsonencode(jsondecode(file("${path.module}/settings/freeschool_search/network.json")))
  storage         = jsonencode(jsondecode(file("${path.module}/settings/freeschool_search/storage.json")))
  ssl_enforcement = false
}
