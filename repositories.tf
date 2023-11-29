locals {
  repository_config = {
    "core-cloud" = {
      visibility = "public"
    },
    "core-cloud-lza-config" = {
      visibility = "internal"
    },
    "core-cloud-github-config" = {
      visibility = "public"
    }
  }

  # Sets the default of specific values if the object key is not set.
  repositories = {
    for k, v in local.repository_config : k => {
      visibility = try(v.visibility, "private")
    }
  }
}

resource "github_repository" "core_cloud_repositories" {
  for_each           = local.repositories
  name               = each.key
  visibility         = each.value.visibility
  has_issues         = false
  has_projects       = false
  has_wiki           = false
  has_downloads      = false
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_team_repository" "core_cloud_admin_team_repositories" {
  for_each = local.repositories
  repository = each.key
  team_id = data.github_team.core_cloud_admin.id
  permission = "admin"
}

resource "github_team_repository" "core_cloud_devops_team_repositories" {
  for_each = local.repositories
  repository = each.key
  team_id = data.github_team.core_cloud_devops.id
  permission = "push"
}
