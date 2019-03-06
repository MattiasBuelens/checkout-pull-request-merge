# checkout-pull-request-merge

## Usage

Checks out the merge commit of a pull request.

* Must be triggered from a `pull_request` event.
* Requires the `GITHUB_TOKEN` secret to fetch the merge commit from the repository.

```
workflow "Pull request" {
  on = "pull_request"
  resolved = "Build pull request"
}
action "Checkout pull request merge" {
  uses = "MattiasBuelens/checkout-pull-request-merge@v0.0.1"
  secrets = ["GITHUB_TOKEN"]
}
action "Build pull request" {
  needs = "Checkout pull request merge"
  uses = "actions/bin/sh@master"
  args = ["make"]
}
```
