#!/bin/zsh

cat html/newgr* | ./code/getprodnos.pl | grep -v -- '-UV$' |grep -v -- '-C$' | sort -u | perl -e '$lst=""; while (<>) { chomp; print "$lst\n" unless $_ eq "$lst-A"; $lst=$_; } print "$lst\n"; ' > prodnos.txt
