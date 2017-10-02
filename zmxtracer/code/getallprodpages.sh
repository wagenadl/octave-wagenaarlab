#!/bin/zsh

for a in `cat prodnos.txt`; do
  [[ -f html/$a.html ]] || wget -O html/$a.html "http://thorlabs.us/thorproduct.cfm?partnumber=$a"
done
