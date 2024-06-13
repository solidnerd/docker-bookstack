#!/usr/bin/env bash

BOOKSTACK_VERSION=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/BookstackApp/Bookstack/releases/latest | \
  jq -r .tag_name
)

echo "Latest: ${BOOKSTACK_VERSION}. Updating.."

sed \
  -i '' \
  -e "s/^ENV BOOKSTACK_VERSION=.*/ENV BOOKSTACK_VERSION=${BOOKSTACK_VERSION}/" \
  Dockerfile
