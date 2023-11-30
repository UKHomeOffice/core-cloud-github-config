terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }
  }
  backend "s3" {
    key = "github/terraform.tfstate"
  }
}

provider "github" {}
