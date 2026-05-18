#!/bin/bash

log_files=$(find . -type f -name "*.log")
py_files=$(find . -type f -name "*.py")
timestamp=$(date +%Y%m%d%H%M%S)
commit_hash=$(git rev-parse --short HEAD)

for file in $log_files; do
    mv $file ${file%.log}_${timestamp}.log
done

for file in $py_files; do
    mv $file ${file%.py}_${commit_hash}.py
done