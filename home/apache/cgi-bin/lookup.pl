#!/usr/bin/perl
# File lookup.pl

use strict;
use warnings;

print "
<html>
	<head>
		<title>Userlookup</title>
	</head>
	<body>
		<center>
			<h2>Userlookup</h2>
		</center>
";

my ($unused, $rawInput) = split(/=/, <STDIN>);

if ($rawInput) {
	my $OK_CHARS='-a-zA-Z0-9_.@';
	my $sanitizedInput = $rawInput;
	$sanitizedInput =~ s/[^$OK_CHARS]//og;
	my $authFile = "/etc/passwd";
	open FILE, $authFile or do {
		warn "Can't open '$authFile': $!";
		return {};
	};
	print "
		<center>
	";
	while (my $line=<FILE>) {
		my ( $uid, $password, $usernr, $groupnr, $info, $homedir,
			$loginshell ) = split(/:/, $line);
		if ($uid eq $sanitizedInput) {
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
	}
	print "
		</table>
		<form method='POST' action='lookup.pl'>\n
		<input type=submit value='Try again'>
		</form>
		</center>
	";
} else {
	print " <center>
		Please enter a username for whom you wish to see data from /etc/passwd:<br>
		<form method='POST' action='lookup.pl'>
		<input type=text name='input'>
		<input type=submit value='send'>
		</form>
		</center>
	";
}
print "
	</body>
</html>
";
