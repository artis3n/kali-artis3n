#!/usr/local/bin/dumb-init /bin/bash 

# Finish ExploitDB setup, ignoring exit code 6
# leaving this commented because it takes a while to run and results in a massive increase in size
# searchsploit -u

# msfdb requires postgres to be up, but the start command will fail because systemd doesn't work in containers.
# so, just ignore the exit code
service postgresql start && msfdb start

set -e
exec "$@"
