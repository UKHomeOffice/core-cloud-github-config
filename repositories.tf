locals {
  default_repo = {
    description = "SAS Core Cloud Repository"

    branch_protection = {
      required_approving_review_count = 2
    }
  }

  repository_config = {
    "core-cloud" = {
      visibility = "public"
      description = "SAS Core Cloud Documentation"
      homepage_url = "https://ukhomeoffice.github.io/core-cloud/"

      branch_protection = {
        required_approving_review_count = 1
      }
    },
    "core-cloud-lza-config" = {
      visibility = "internal"
      description = "SAS Core Cloud LZA Config"
    },
    "core-cloud-github-config" = {
      visibility = "public"
      description = "GitHub repository configuration for Core Cloud repositories"
    }
  }

  # Sets the default of specific values if the object key is not set.
  repositories = {
    for k, v in local.repository_config : k => merge(local.default_repo, v)
  }
}

resource "github_repository" "core_cloud_repositories" {
  for_each           = local.repositories
  name               = each.key
  description        = each.value.description
  visibility         = each.value.visibility
  has_issues         = false
  has_projects       = false
  has_wiki           = false
  has_downloads      = false
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false
  allow_update_branch = true
  delete_branch_on_merge = true
  homepage_url       = try(each.value.homepage_url, null)

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      pages
    ]
  }
}

resource "github_team_repository" "core_cloud_admin_team_repositories" {
  for_each   = local.repositories
  repository = each.key
  team_id    = data.github_team.core_cloud_admin.id
  permission = "admin"

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}

resource "github_team_repository" "core_cloud_devops_team_repositories" {
  for_each   = github_repository.core_cloud_repositories
  repository = each.key
  team_id    = data.github_team.core_cloud_devops.id
  permission = "push"

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}

resource "github_branch_protection" "main" {
  for_each      = github_repository.core_cloud_repositories
  repository_id = each.key

  pattern                         = "main"
  enforce_admins                  = true
  required_linear_history         = true
  require_conversation_resolution = true
  allows_force_pushes             = false
  allows_deletions                = false

  required_pull_request_reviews {
    require_last_push_approval      = true
    required_approving_review_count = local.repositories[each.key].branch_protection.required_approving_review_count
  }

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}

resource "github_actions_repository_permissions" "core_cloud_repositories" {
  for_each   = github_repository.core_cloud_repositories
  repository = each.key

  allowed_actions = "selected"
  enabled         = true

  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = true
    patterns_allowed = [
      "aws-actions/*"
    ]
  }

  depends_on = [
    github_repository.core_cloud_repositories
  ]
}
