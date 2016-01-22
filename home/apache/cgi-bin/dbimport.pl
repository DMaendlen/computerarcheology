#!/usr/bin/perl
# import data from ./passwd.bsp into db mydb, table passwd
# assumes postgresql was started using:
# su postgres; postmaster -D /var/lib/pgsql/ &

use strict;
use warnings;
use DBI;

# setup db connection
my $driver = "Pg";
my $database = "mydb";
my $dsn = "DBI:$driver:dbname=$database;host=127.0.0.1;port=5432";
my $userid = "apache";
my $password = "apache";
my $dbh = DBI->connect($dsn, $userid, $password, {RaiseError => 1})
		or die $DBI::errstr;

# cleanup
my $sth_drop = $dbh->prepare("DROP TABLE passwd");
$sth_drop->execute();

# create db handler for table cration
my $sth_create = $dbh->prepare("CREATE TABLE passwd (
	username varchar(255),
	password varchar(255),
	usernumber varchar(255),
	groupnumber varchar(255),
	info varchar(255),
	homedir varchar(255),
	loginshell varchar(255));");

# execute db handler
$sth_create->execute();

# read file
my $filename = "passwd.bsp";
open FILE, $filename or do {
	warn "Can't open '$filename': $!";
	return {};

};

# create db handler for data insertion
my $sth_insert = $dbh->prepare("INSERT INTO passwd VALUES (?,?,?,?,?,?,?)");
while (my $line = <FILE>) {
	my ($uid, $password, $usernr, $groupnr, $info, $homedir, $loginshell)
		= split(/:/, $line, 7);
		# execute db handler for every line in the file
	$sth_insert->execute(
		$uid, $password, $usernr, $groupnr, $info,
		$homedir, $loginshell);
}
close FILE;

# create db handler for lookup
my $select_sth = $dbh->prepare("SELECT * FROM passwd");

# execute db handler for lookup
$select_sth->execute();

# print for debugging
#while (my @row = $select_sth->fetchrow_array) {
#	print("Result: @row\n")
#}
