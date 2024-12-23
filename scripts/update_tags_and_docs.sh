#!/usr/bin/env bash

# Get the root of the Git repository in order to correctly path e.g. Dockerfile
GIT_ROOT=$(git rev-parse --show-toplevel)

# Extract the version from the Dockerfile, as there could have been a new
# release since the last run.

BOOKSTACK_VERSION=$(awk \
  '/ENV BOOKSTACK_VERSION/{split($2,b,"="); print b[2]}' \
  "${GIT_ROOT}/Dockerfile"
)

echo "Extracted version: ${BOOKSTACK_VERSION}"

# Remove the 'v' for our tags
BOOKSTACK_VERSION="${BOOKSTACK_VERSION/#v/}"
# Remove leading zeros to make the version fit a SemVer-shaped hole
BOOKSTACK_VERSION="${BOOKSTACK_VERSION//.0?/.}"

# If the version only has one decimal dot in it, it doesn't have a patch
# version and one should be added to ensure semver-shape.
BS_DECIMALS="${BOOKSTACK_VERSION//[^.]}"
if [[ "${#BS_DECIMALS}" -eq "1" ]]; then
  BOOKSTACK_VERSION="${BOOKSTACK_VERSION}.0"
fi

echo "Tag name: ${BOOKSTACK_VERSION}"

git tag -s -a "${BOOKSTACK_VERSION}" -m "Release version ${BOOKSTACK_VERSION}"
git push --tags

echo "Extracting old version info.."
OLD_BS_VERSION="$(cat VERSION)"

echo "Updating README and reference docker-compose.yml.."
sed \
  -i '' \
  -e "s/${OLD_BS_VERSION}/${BOOKSTACK_VERSION}/g" \
  "${GIT_ROOT}/README.md" \
  "${GIT_ROOT}/docker-compose.yml"

echo "Updating VERSION file.."
echo "${BOOKSTACK_VERSION}" > "${GIT_ROOT}/VERSION"

git add \
  "${GIT_ROOT}/README.md" \
  "${GIT_ROOT}/docker-compose.yml" \
  "${GIT_ROOT}/VERSION"

git commit -S -m "doc: update documentation to reference ${BOOKSTACK_VERSION}"
git push
