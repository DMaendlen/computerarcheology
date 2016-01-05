#!/usr/bin/perl

use strict;
use warnings;

my $filename = "passwd.bsp";

open INFILE, $filename or do{
	warn "Couldn't open $filename: $!";
	return {};
};
while (my $line = <INFILE>) {
	chomp($line);
	my ($uid, $unused) = split(/:/, $line, 2);
	open(OUTFILE, '>', "passwd.$uid") or do {
		warn "Couldn't open $filename: $!";
		return {};
	};
	print(OUTFILE $line);
	close(OUTFILE);
}

close(INFILE)
