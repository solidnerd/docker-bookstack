#!/usr/bin/env bash

echo "Fetching latest Bookstack release from GitHub API"

BOOKSTACK_VERSION=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/BookstackApp/Bookstack/releases/latest | \
  jq -r .tag_name
)

echo "Found latest version: ${BOOKSTACK_VERSION}"

# Get the root of the Git repository in order to correctly path e.g. Dockerfile
GIT_ROOT=$(git rev-parse --show-toplevel)

echo "Updating Dockerfile.."
sed \
  -i '' \
  -e "s/^ENV BOOKSTACK_VERSION=.*/ENV BOOKSTACK_VERSION=${BOOKSTACK_VERSION}/" \
  "${GIT_ROOT}/Dockerfile"

git add "${GIT_ROOT}/Dockerfile"
git commit -S -m "feat: update Dockerfile to use Bookstack ${BOOKSTACK_VERSION}"
