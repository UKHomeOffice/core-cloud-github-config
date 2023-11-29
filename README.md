# Core Cloud Repository Configuration

This repository contains the configuration for the Core Cloud GitHub repositories and utilises Terraform to ensure 
consistency in configuration. This facilitates the monitoring of any drift from the desired state.

The following settings are configured:
- Repositories
- Repository Team Membership

## Configuration

Repositories have to be manually added to locals block within the [repositories](./repositories.tf) file. This ensures only repositories 
that are explicitly owned by the Core Cloud team are managed.

### Configurable Settings

Each repository has a number of configurable settings. These can be altered by adding the setting into the required repositories object.

The following settings are currently configurable:

| Setting                                           | Description                                             | Default |
|---------------------------------------------------|---------------------------------------------------------|---------|
| visibility                                        | The visibility of the repository                        | private |
| branch_protection.required_approving_review_count | The number of approving reviews required before merging | 1       |

It is designed so that additional settings can be added as required, with sensible defaults provided.
