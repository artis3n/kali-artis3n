#!/bin/bash 

set -e

service postgresql start 
msfdb init

exec "$@"
