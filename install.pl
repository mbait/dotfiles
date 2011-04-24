#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

open FH, "files.path";
my %list;
while (<FH>) {
	my ($file, $path) = split /\s+/;
	$path ||= '~';
	$list{$file} = $path;
}
close FH;

my $cwd = getcwd;
while (<{.,?}*>) {
	if (exists $list{$_}) {
		system "ln -s $cwd/$_ $list{$_}";
	} else {
		warn "Skip '$_' - has no corresponding path";
	}
}
