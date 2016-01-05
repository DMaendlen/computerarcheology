#!/usr/bin/perl
# File makepix.pl

use strict;
use warnings;

print "
<html>
	<head>
		<title>Makepix</title>
	</head>
	<body>
		<center>
			<h2>Convert xpm to png</h2>
		</center>
";

my ($unused, $rawInput) = split(/=/, <STDIN>);

if($rawInput) {
	my $xpmFile = "/home/apache/tmp/input.xpm";
	my $pngFile = "/home/apache/icons/output.png";
	open(my $filehandle, '>:encoding(UTF-8)', $xpmFile)
		or die "Could not open file '$xpmFile' $!";
	print $filehandle "$rawInput";
	close $filehandle;
	`convert $xpmFile $pngFile`;
	print "
		<center>
		Your converted file is:<br>
		<img src='/icons/output.png' /><br>
		<form method='POST' action='makepix.pl'>
		<input type=submit value='retry'>
		</form>
		</center>
	";
	`rm $xpmFile; rm $pngFile;`;
	
} else {
	print "
		<center>
		Please enter the xpm-code for a picture you'd like to convert.
		<form method='POST' action='makepix.pl'>
		<input type=text size='65535' name='input'><br>
		<input type=submit value='send'>
		</form>
		</center>
	";
}

print "
	</body>
</html>
";
