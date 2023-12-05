# GitHub Configuration

## Workflows

We use GitHub Actions and Workflows to automate processes within the repository.

These actions can be found within the [workflows](./workflows) directory.

## Dependabot

[Dependabot](https://docs.github.com/en/code-security/dependabot/working-with-dependabot) is used within the project to automatically update relevant dependencies within the
repository. It is configured to check daily and submit pull requests with version bumps.

The configuration can be found within the [dependabot.yaml](./dependabot.yaml) file.
