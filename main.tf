terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2.0"
    }
  }
  backend "s3" {
    key = "github/terraform.tfstate"
  }

  required_version = "~>1.7.0"
}

provider "github" {
  app_auth {}
}
