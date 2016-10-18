#!/usr/bin/perl -w

use strict;

my $gotcha = 0;
while (<>) {
  chomp;
  my @bits = split(/\s/);
  for (@bits) {
    if (/href="(.*\/([^\/]+)-Zemax.*\.zmx)"/) {
      my $url = $1;
      my $name = $2;
      unless (-f "zmx/$name.zmx") {
	print "URL=[$url] NAME=[$name]\n";
	system("wget -O zmx/$name.zmx '$url'");
      }
    } elsif (/href="(.*fileName=.*.zmx.*partNumber=(.*))"/) {
      my $url = "https://www.thorlabs.us/$1";
      my $name = $2;
      unless (-f "zmx/$name.zmx") {
	print "URL=[$url] NAME=[$name]\n";
	system("wget -O zmx/$name.zmx '$url'");
      }
    }
  }
}
