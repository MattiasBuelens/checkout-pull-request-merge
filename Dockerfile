FROM debian:stable-slim

LABEL "com.github.actions.name"="Check out pull request merge"
LABEL "com.github.actions.description"="Checks out the merge commit of a pull request."
LABEL "com.github.actions.icon"="git-merge"
LABEL "com.github.actions.color"="purple"

LABEL "maintainer"="Mattias Buelens"
LABEL "version"="0.0.1"
LABEL "repository"="http://github.com/MattiasBuelens/checkout-pull-request-merge"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
