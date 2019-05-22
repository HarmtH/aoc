#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines[0].comb(/\w+/);
    my %map = 'n'  => ( 0, 2),
              'ne' => ( 1, 1),
              'se' => ( 1,-1),
              's'  => ( 0,-2),
              'sw' => (-1,-1),
              'nw' => (-1, 1);
    my @coord = (0,0);
    my @ans = (0,0);
    for @arr -> $dir {
        @coord <<+=>> %map{$dir};
        @ans[0] = @coord[0].abs + max(@coord[1].abs - @coord[0].abs, 0) / 2;
        @ans[1] = max(@ans[1], @ans[0]);
    }
    @ans[$ex];
}

is run('11.t1', 0), 3;
is run('11.t2', 0), 0;
is run('11.t3', 0), 2;
is run('11.t4', 0), 3;
done-testing;

say run('11.in', 0);
say run('11.in', 1);
