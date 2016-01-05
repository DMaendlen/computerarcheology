#!/usr/bin/perl

use strict;
use warnings;

my $filename = $ARGV[0];

open INFILE, $filename or do{
	warn "Couldn't open $filename: $!";
	return {};
};

unless ( -d "passwd" ) {
	mkdir "passwd" or die "Error creating passwd-dir: $!";
};

unless ( -d "ldif" ) {
	mkdir "ldif" or die "Error creating ldif-dir: $!";
};

while (my $line = <INFILE>) {
	chomp($line);
	my ($uid, $unused) = split(/:/, $line, 2);
	open(OUTFILE, '>', "passwd/passwd.$uid") or do {
		warn "Couldn't open $filename: $!";
		return {};
	};
	print(OUTFILE $line);
	close(OUTFILE);
}
close(INFILE);

opendir(PASSWD, "passwd") or die "Can't open passwd: $!";
while (my $file = readdir PASSWD) {
	my ($unused, $uid) = split(/\./, $file);
	`/usr/share/openldap/migration/migrate_passwd.pl $file "ldif/$uid.ldif"`
}
closedir PASSWD;

