#!/bin/sh -l

set -e

if [ $GITHUB_EVENT_NAME != "pull_request" ]; then
  echo "This action can only be run on a 'pull_request' event."
  exit 1
fi

pr_action=$(jq --raw-output '.action' $GITHUB_EVENT_PATH)
if [ $pr_action != "opened" ] && [ $pr_action != "reopened" ] && [ $pr_action != "synchronize" ]; then
  echo "Skipping pull request action: \"$pr_action\""
  exit 78
fi

pr_draft=$(jq --raw-output '.pull_request.draft' $GITHUB_EVENT_PATH)
if [ $pr_draft = "true" ]; then
  echo "Skipping draft pull request."
  exit 78
fi

pr_merged=$(jq --raw-output '.pull_request.merged' $GITHUB_EVENT_PATH)
if [ $pr_merged = "true" ]; then
  echo "Skipping merged pull request."
  exit 78
fi

pr_number=$(jq --raw-output '.pull_request.number' $GITHUB_EVENT_PATH)

original_remote=$(git remote get-url origin)
git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"

git fetch origin refs/pull/$pr_number/merge
git checkout --force FETCH_HEAD
git submodule update --init

git remote set-url origin $original_remote
