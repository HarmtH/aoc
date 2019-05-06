#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines;
    my $ans = 0;
    if $ex == 0 {
        $ans = 0;
    } elsif $ex == 1 {
        $ans = 1;
    }
    $ans;
}

is run('tpl.t1', 0), 0;
is run('tpl.t2', 1), 1;
done-testing;

say run('tpl.in', 0);
say run('tpl.in', 1);
