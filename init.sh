#!/bin/sh
set -e

# Just start supervisor — nginx config is clean now
exec /usr/bin/supervisord -c /etc/supervisord.conf
