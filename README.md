# Core Cloud Repository Configuration

This repository contains the configuration for the Core Cloud GitHub repositories and utilises Terraform to ensure 
consistency in configuration. This facilitates the application of desired state and monitoring drift.

The following settings are configured:
- Repositories
- Repository Team Membership
- Repository Branch Protection
- Repository Action Permissions

## Configuration

Repositories have to be manually added to locals block within the [repositories](./repositories.tf) file. This ensures 
only repositories that are explicitly owned by the Core Cloud team are managed.

### Configurable Settings

Each repository has a number of configurable settings. These can be altered by adding the setting into the locals 
repositories object.

> Visibility can be one of `public`, `private`, or `internal`. It does not have a default value and must be set on each 
> repository.
