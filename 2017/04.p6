#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = [ [ .split(' ') ] for $infile.IO.lines ];
    if $ex == 0 {
        return [+] [(set(@$_) == @$_) for @arr];
    } elsif $ex == 1 {
        return [+] ( (set((.comb.sort.join for @$_)) == @$_) for @arr );
    }
}

is run('04.t1', 0), 1;
is run('04.t2', 0), 0;
is run('04.t3', 0), 1;
is run('04.t4', 1), 1;
is run('04.t5', 1), 0;
done-testing;

say run('04.in', 0);
say run('04.in', 1);
