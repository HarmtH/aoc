#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = [ [ .comb(/\d+/)>>.Int ] for $infile.IO.lines ];
    if $ex == 0 {
        @arr.grep({.[0] %% (2 * .[1] - 2)}).map({.[0] * .[1]}).sum 
    } elsif $ex == 1 {
        my $delay = 0;
        while @arr.grep({(.[0] + $delay) %% (2 * .[1] - 2)}) {$delay++}
        $delay;
    }
}

is run('13.t1', 0), 24;
is run('13.t1', 1), 10;
done-testing;

say run('13.in', 0);
say run('13.in', 1);
