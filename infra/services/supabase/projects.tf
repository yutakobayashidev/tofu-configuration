resource "supabase_project" "freeschool_search" {
  name            = "freeschool-search"
  organization_id = "hbkytjldratowfawojlk"
  region          = "ap-northeast-1"
  # Existing password is unknown. Import only; never use this placeholder to create a project.
  database_password = "unused-for-import"

  lifecycle {
    ignore_changes  = [database_password]
    prevent_destroy = true
  }
}

resource "supabase_project" "stable_share" {
  name            = "Stable share"
  organization_id = "mhmfmbpfqscxbdozroom"
  region          = "ap-northeast-1"
  # Existing password is unknown. Import only; never use this placeholder to create a project.
  database_password = "unused-for-import"

  lifecycle {
    ignore_changes  = [database_password]
    prevent_destroy = true
  }
}

resource "supabase_project" "capitalens" {
  name            = "CapitaLens"
  organization_id = "lfvzbxrbmphseajkzjho"
  region          = "ap-northeast-1"
  # Existing password is unknown. Import only; never use this placeholder to create a project.
  database_password = "unused-for-import"

  lifecycle {
    ignore_changes  = [database_password]
    prevent_destroy = true
  }
}
