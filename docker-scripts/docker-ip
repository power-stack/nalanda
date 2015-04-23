#!/bin/sh

exec sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
