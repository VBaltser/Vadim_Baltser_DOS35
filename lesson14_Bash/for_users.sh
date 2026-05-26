#!/bin/bash
file="${1:-/var/users}"

for line in $(cat "$file")
do
  echo In this line: $line
done
