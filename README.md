# github-workflows

Reusable GitHub Actions workflows shared by PrimeSeventyThree's repositories.

## Claude (`.github/workflows/claude.yml`)

Answers `@claude` in issues, comments and pull request reviews with Anthropic's
[Claude Code GitHub Action](https://github.com/anthropics/claude-code-action): it can answer
questions, push fixes to a branch and prepare pull requests. Only people with write access to a
repository can trigger it; bots can't.

### Add it to a repository

1. Install the [Claude GitHub App](https://github.com/apps/claude) on the repository
   (Settings › Applications › Claude › Configure, then add the repository).
2. Add the `CLAUDE_CODE_OAUTH_TOKEN` secret: run `scripts/set-token.sh <repo>...` from this
   repository (it asks for the token from `claude setup-token` without echoing it).
3. Add `.github/workflows/claude.yml` to the repository:

```yaml
name: Claude

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  pull_request_review:
    types: [submitted]
  issues:
    types: [opened]

jobs:
  claude:
    uses: PrimeSeventyThree/github-workflows/.github/workflows/claude.yml@v1
    permissions:
      contents: write
      pull-requests: write
      issues: write
      id-token: write
      actions: read
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    # with:
    #   model: claude-sonnet-5-5
    #   max_turns: 40
    #   runs_on: macos-15   # for Xcode work; paid minutes on private repositories
```

The caller lists the permissions because a reusable workflow can't have more than its caller
grants.

### Changing it

Edit the workflow here, then move the `v1` tag (`git tag -f v1 && git push -f origin v1`) so
every repository picks up the change. Make a `v2` tag for changes that need callers to change.

Each repository's `CLAUDE.md` or `AGENTS.md` is where its own rules go; the workflow tells
Claude to read `AGENTS.md` and follow its Git workflow.
