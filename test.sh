#!/bin/bash

test=$(curl -sS https://docs.docker.com/compose/install/ | grep 'https://github.com/docker/compose/releases/download/' | head -n 1 | grep -Po '(?<=download/)[^;/]+')
echo $test