#!/bin/bash 

set -e

service postgresql start
msfdb start

exec "$@"
