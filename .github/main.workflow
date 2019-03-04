workflow "Test on push" {
  on = "push"
  resolves = ["Test push"]
}

workflow "Test on pull request" {
  on = "pull_request"
  resolves = ["Test pull request"]
}

action "Checkout pull request merge" {
  uses = "./"
}

action "Test push" {
  uses = "actions/bin/sh@master"
  args = ["chmod +x ./test/test.sh && ./test/test.sh"]
}

action "Test pull request" {
  needs = "Checkout pull request merge"
  uses = "actions/bin/sh@master"
  args = ["chmod +x ./test/test.sh && ./test/test.sh"]
}
