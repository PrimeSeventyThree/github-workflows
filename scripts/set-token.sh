#!/usr/bin/env bash
# Stores the Claude subscription token as the CLAUDE_CODE_OAUTH_TOKEN Actions secret in each
# repository given. Asks for the token once, without echoing it; get one with
# `claude setup-token`.
#
# Usage: scripts/set-token.sh <repo>...      e.g. scripts/set-token.sh keyline lde
#        (owner PrimeSeventyThree unless given as owner/repo)
set -euo pipefail

[[ $# -gt 0 ]] || { echo "usage: scripts/set-token.sh <repo>..." >&2; exit 2; }

read -r -s -p "Token from 'claude setup-token': " token
echo
[[ -n "$token" ]] || { echo "error: no token entered" >&2; exit 1; }

for repo in "$@"; do
  [[ "$repo" == */* ]] || repo="PrimeSeventyThree/$repo"
  # Without --body, gh reads the value from stdin, so the token never appears in a command line.
  printf '%s' "$token" | gh secret set CLAUDE_CODE_OAUTH_TOKEN --repo "$repo"
  echo "set CLAUDE_CODE_OAUTH_TOKEN in $repo"
done
