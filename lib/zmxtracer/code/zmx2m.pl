#!/usr/bin/perl -w

use strict;

my $name;
my $desc;
my @curv;
my @tc;
my @glass;
my $conj1 = "nan";
my $conj2 = "nan";
my $curv1 = "nan";
my $curv2 = "nan";
my $surfn = -1;
my @diam;

my $fn = shift @ARGV;
# Some of Thor's files are UTF16-encoded. Perl can deal, but not trivially:
open IN, "<:encoding(UTF-16)", "$fn" or die "Cannot read file";
eval {
  my $dummy = <IN>;
  for my $x (0..length($dummy)-1) {
    die if ord(substr($dummy,$x,1))>126;
  }
} or do {
  close IN;
  open IN, "<", "$fn" or die "Cannot read file";
};

$name = $fn;
$name =~ s/^.*\///;
$name =~ s/\.zmx$//;
$desc = "$name";

print STDERR "Reading $fn\n";

while (<IN>) {
  chomp;
  #  print STDERR ":: $_ ::";
  s/^\s+//;
  s/\s+$//;
  my @vv = split(/\s+/, $_);
  my $k = shift @vv;
  my $v = $vv[0];
  if ($k eq "NAME") {
    my $n = $vv[0];
    if ($n eq $name) {
      shift @vv;
      shift @vv if $vv[0] eq "-";
    }
    $desc = join(" ", @vv);
  } elsif ($k eq "SURF") {
    $surfn = $v;
  } elsif ($k eq "BLNK") {
    $surfn = -1;
  } elsif ($k eq "CURV") {
    if ($surfn==0) {
      $curv1 = $v+0;
    } else {
      $curv[$surfn-1] = $v+0;
    }
  } elsif ($k eq "DISZ") {
    if ($surfn==0) {
      $conj1 = $v;
    } else {
      push @tc, $v + 0;
    }
  } elsif ($k eq "DIAM") {
    push @diam, 2*$v if $surfn>0;
  } elsif ($k eq "GLAS") {
    $glass[$surfn-1] = $v if $surfn>0;
  }
}

die "No name found in .zmx file\n" unless defined $name;

pop @diam;

for (@glass) {
  $_ = "(x) (1)" unless defined $_;
  $_ =~ s/-//g;
  $_ = "@" . lc($_);
}

$curv2 = pop @curv;
pop @tc;
$conj2 = pop @tc;

for (@tc) {
  s/INFINITY/inf/;
}
if ($conj1 eq "INFINITY") {
  $conj1 = "inf";
} else {
  $conj1 += 0;
}
if ($conj2 eq "INFINITY") {
  $conj2 = "inf";
} else {
  $conj2 += 0;
}

my $ofn = $name;
$ofn =~ s/-//g;
$ofn = lc($ofn);
$ofn =~ s/a$//;

open OUT, ">lenses/$ofn.m" or die "Cannot write .m file\n";

print OUT "function lens = $ofn\n";
print OUT "% " . uc($fn) . " - $desc\n";
print OUT "\n";
print OUT "lens.fn = '$ofn';\n";
print OUT "lens.name = '$name';\n";
print OUT "lens.diam = [ " . join(", ", @diam) . " ];\n";
print OUT "lens.glass = { " . join(", ", @glass) . " };\n";
print OUT "lens.curv = [ " . join(", ", @curv) . " ];\n";
print OUT "lens.tc = [ " . join(", ", @tc) . " ];\n";
print OUT "lens.conj = [ $conj1, $conj2];\n";
print OUT "lens.conjcurv = [ $curv1, $curv2];\n";

# print OUT "if exist('${ofn}_pp')\n";
# print OUT "  lens.pplane = \@${ofn}_pp;\n";
# print OUT "else\n";
# print OUT "  lens.pplane = \@(varargin) (makepplane(varargin{:}, lens));\n";
# print OUT "end\n";

