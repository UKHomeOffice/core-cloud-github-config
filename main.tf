terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }
  }
}

provider "github" {
  owner = "UKHomeOffice" # TODO: this may want to be sourced from the `GITHUB_OWNER` action environment variable
  token = "" # TODO: this should be passed through as a environment variable in the action `GITHUB_TOKEN`
}
