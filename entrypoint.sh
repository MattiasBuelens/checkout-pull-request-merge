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

mergeable=$(jq --raw-output '.pull_request.mergeable' $GITHUB_EVENT_PATH)
if [ $mergeable = "null" ]; then
  echo "Skipping pull request with unknown mergeability."
  exit 78
elif [ $mergeable != "true" ]; then
  echo "This pull request is not mergeable."
  exit 1
fi

merge_commit_sha=$(jq --raw-output '.pull_request.merge_commit_sha' $GITHUB_EVENT_PATH)
git checkout --force $merge_commit_sha
