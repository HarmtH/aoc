#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = [ [ .comb(/\d+/).map(*.Int) ] for $infile.IO.lines ];
    my $ans;
    for @arr -> @row {
        if $ex == 0 {
            $ans += @row.max - @row.min;
        } elsif $ex == 1 {
            for ^@row X ^@row -> ($i, $j) {
                if $i != $j && @row[$i] %% @row[$j] {
                    $ans += @row[$i] / @row[$j];
                    last;
                }
            }
        }
    }
    $ans;
}

is run('02.t1', 0), 18;
is run('02.t2', 1), 9;
done-testing;

say run('02.in', 0);
say run('02.in', 1);
