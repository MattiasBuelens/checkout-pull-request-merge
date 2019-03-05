#!/bin/sh -l

set -e

if [ $GITHUB_EVENT_NAME != "pull_request" ]; then
  echo "This action can only be run on a 'pull_request' event."
  exit 1
fi

draft=$(jq --raw-output '.pull_request.draft' $GITHUB_EVENT_PATH)
if [ $draft = "true" ]; then
  echo "Skipping draft pull request."
  exit 78
fi

merged=$(jq --raw-output '.pull_request.merged' $GITHUB_EVENT_PATH)
if [ $merged = "true" ]; then
  echo "Skipping merged pull request."
  exit 78
fi

pr_number=$(jq --raw-output '.pull_request.number' $GITHUB_EVENT_PATH)

original_remote=$(git remote get-url origin)
git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"

git fetch origin refs/pull/$pr_number/merge
git checkout --force --recurse-submodules FETCH_HEAD

git remote set-url origin $original_remote
