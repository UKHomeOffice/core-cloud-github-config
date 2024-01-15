terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.44.0"
    }
  }
  backend "s3" {
    key = "github/terraform.tfstate"
  }

  required_version = "~>1.6.0"
}

provider "github" {}
