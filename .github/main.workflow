workflow "Test on push" {
  on = "push"
  resolves = ["Test"]
}

action "Test" {
  uses = "actions/bin/sh@master"
  args = "./test/test.sh"
}
