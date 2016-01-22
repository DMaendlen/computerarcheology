#!/usr/bin/perl
# file: /bin/bitshift.pl
# find out how bit shifting works

use strict;
use warnings;

my $tty_nr = 34816;
my $minor_mask = 0xFFFF00FF;
my $major_mask = 0xFF00;

my $major_nr = $tty_nr & $major_mask;
$major_nr = $major_nr >> 8;
my $minor_nr = $tty_nr & $minor_mask;

print("major: $major_nr\n");
print("minor: $minor_nr\n");
