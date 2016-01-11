#!/usr/bin/perl
# File dbinfo.pl

use strict;
use warnings;
use DBI;

print "
<html>
<head>
<title>DB Info</title>
</head>
<body>
<center>
<h2>DB Info</h2>
</center>
";

my ($rawUidInput, $rawPwInput) = split(/\&/, <STDIN>);
my ($unusedUid, $rawUid) = split(/=/, $rawUidInput);
my ($unusedPw, $rawPw) = split(/=/, $rawPwInput);
my $sanitizedUid = $rawUid;
my $sanitizedPw = $rawPw;

if ($rawUid) {
	# sanitize Input
	my $OK_CHARS='a-zA-Z0-9_.@\$';
	$sanitizedPw =~ s/\%24/\$/g;
	$sanitizedUid =~ s/[^$OK_CHARS]//g;
	$sanitizedPw =~ s/[^$OK_CHARS]//g;

	# connect to DB
	my $driver = "Pg";
	my $database = "mydb";
	my $dsn = "DBI:$driver:dbname=$database;host=127.0.0.1;port=5432";
	my $userid = "apache";
	my $password = "apache";
	my $dbh = DBI->connect($dsn, $userid, $password, {RaiseError => 1})
		or die $DBI::errstr;

	# get & show result 
	print "
	<center>
	";
	my $select_sth = $dbh->prepare("SELECT *
		FROM passwd
		WHERE username = ?
			AND password = ?");
	$select_sth->execute($sanitizedUid, $sanitizedPw);
	while (my ($uid, $password, $usernr, $groupnr, $info, $homedir,
			$loginshell)= $select_sth->fetchrow_array) {
		print "
		Your chosen user was: $uid<br><br>
		<table border='1' width='50%'>
		<tr>
		<th>Attribute</th>
		<th>Info</th>
		</tr>
		<tr>
		<td>UID</td>
		<td>$uid</td>
		</tr>
		<tr>
		<td>Password</td>
		<td>$password</td>
		</tr>
		<tr>
		<td>Usernumber</td>
		<td>$usernr</td>
		</tr>
		<tr>
		<td>Groupnumber</td>
		<td>$groupnr</td>
		</tr>
		<tr>
		<td>Info</td>
		<td>$info</td>
		</tr>
		<tr>
		<td>Homedir</td>
		<td>$homedir</td>
		</tr>
		<tr>
		<td>Loginshell</td>
		<td>$loginshell</td>
		</tr>
		";
	}
	print "
	</table>
	<form method='POST' action='dbinfo.pl'>\n
	<input type=submit value='Try again'>
	</form>
	</center>
	";
} else {
	print " <center>
	Please enter a username for whom you wish to see data from /etc/passwd:<br>
	<form method='POST' action='dbinfo.pl'>
	<input type=text name='username'>
	<input type=text name='password'
	<input type=submit value='send'>
	</form>
	</center>
	";
}
print "
</body>
</html>
";
