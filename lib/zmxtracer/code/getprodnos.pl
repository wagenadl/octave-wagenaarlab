#!/usr/bin/perl -w

use strict;

my %parts;

while (<>) {
  chomp;
  my @bits = split(/\s+/);
  for (@bits) {
    /partnumber=(.*?)"/ or next;
    my $part = $1;
    $parts{$part} = 1;
  }
}

for (sort keys %parts) {
  print "$_\n";
}
