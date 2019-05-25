#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    # my @in = $infile.IO.lines[0].comb;
    # my @in = [ [ .comb ] for $infile.IO.lines ];
    my @ans = (0,0);
    @ans[$ex];
}

is run('tpl.t1', 0), 1;
# is run('tpl.t1', 1), 1;
done-testing;

# say run('tpl.in', 0);
# say run('tpl.in', 1);
