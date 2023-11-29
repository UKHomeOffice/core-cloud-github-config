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

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}

resource "github_team_repository" "core_cloud_devops_team_repositories" {
  for_each = local.repositories
  repository = each.key
  team_id = data.github_team.core_cloud_devops.id
  permission = "push"

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}

resource "github_branch_protection" "main" {
  for_each = local.repositories
  repository_id = github_repository.core_cloud_repositories[each.key].node_id

  pattern       = "main"
  enforce_admins = true
  required_linear_history = true
  require_conversation_resolution = true
  allows_force_pushes = false
  allows_deletions = false

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    require_last_push_approval = true # TODO: this is not in the AC but feels appropriate
    required_approving_review_count = 1 # TODO: should this be 1/2, I think some repositories we would want this to be 2 but not all to keep pace.
  }

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}
