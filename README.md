# checkout-pull-request-merge

## Usage

Checks out the merge commit of a pull request.

Must be triggered from a `pull_request` event.

```
workflow "Pull request" {
  on = "pull_request"
  resolved = "Build pull request"
}
action "Checkout pull request merge" {
  uses = "mattiasbuelens/checkout-pull-request-merge@master"
}
action "Build pull request" {
  needs = "Checkout pull request merge"
  uses = "actions/bin/sh@master"
  args = ["make"]
}
```
