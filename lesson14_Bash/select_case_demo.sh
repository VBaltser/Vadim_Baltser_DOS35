#!/bin/bash
select number in 1 2 3 stop
do
  case $number in
    1) echo One;;
    2) echo Two;;
    3) echo Three;;
    stop) break ;;
    *) echo something wrong ;;
  esac
done
echo "Menu finished"
