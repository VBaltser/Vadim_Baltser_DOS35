#!/bin/bash
number=one
case $number in
  one) echo 1;;
  two) echo 2;;
  *) echo something wrong ;;
esac
