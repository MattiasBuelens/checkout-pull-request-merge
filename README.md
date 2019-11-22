# checkout-pull-request-merge (DEPRECATED)

Checks out the merge commit of a pull request.

This GitHub Action was written for the old HCL syntax, which is [no longer supported](https://github.blog/changelog/2019-10-01-github-actions-hcl-workflows-are-no-longer-being-run/).

## Alternative

With [the new YAML syntax](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions), you can pass the [`merge_commit_sha`](https://developer.github.com/v3/pulls/#response-1) from [the `pull_request` event payload](https://developer.github.com/v3/activity/events/types/#pullrequestevent) as `ref` parameter to [actions/checkout](https://github.com/actions/checkout):
```yaml
name: Test on pull request
on: [pull_request]
jobs:
  test_pull_request:
    runs-on: ubuntu-latest
    steps:
      - name: Check out merge commit of pull request
        uses: actions/checkout@v1
        with:
          ref: ${{ github.event.pull_request.merge_commit_sha }}
      - name: Test
        run: npm install && npm test
```

You can then use [`jobs.<job_id>.if`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobsjob_idif) to only run your job when it's possible to merge the pull request:
```yaml
name: Test on pull request
on: [pull_request]
jobs:
  test_pull_request:
    # Run only on non-merged non-draft mergeable pull requests
    if: |
      !(
        (github.event.action == 'opened' || github.event.action == 'reopened' || github.event.action == 'synchronize')
        && !github.event.pull_request.draft
        && !github.event.pull_request.merged
        && github.event.pull_request.merge_commit_sha != null
      )
    runs-on: ubuntu-latest
    steps:
      # ...
```

For a complete example, see [this workflow](https://github.com/MattiasBuelens/checkout-pull-request-merge/blob/master/.github/workflows/pull-request.yml).
