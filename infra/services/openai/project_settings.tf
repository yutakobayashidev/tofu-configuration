resource "openai_project_data_retention" "default" {
  project_id = openai_project.default.id
  type       = "organization_default"
}

resource "openai_project_hosted_tool_permissions" "default" {
  project_id               = openai_project.default.id
  code_interpreter_enabled = true
  file_search_enabled      = true
  image_generation_enabled = true
  mcp_enabled              = true
  web_search_enabled       = true
}
