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

merge_commit_sha=$(jq --raw-output '.pull_request.merge_commit_sha' $GITHUB_EVENT_PATH)
if [ $merge_commit_sha = "null" ]; then
  echo "This pull request is not mergeable."
  exit 1
fi

git checkout --force $merge_commit_sha
