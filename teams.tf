data "github_team" "core_cloud_devops" {
  slug = "core-cloud-devops"
}

data "github_team" "core_cloud_admin" {
  slug = "core-cloud-admin"
}

resource "github_team" "core_cloud_code_owners" {
  name           = "core-cloud-code-owners"
  parent_team_id = data.github_team.core_cloud_devops.id
}