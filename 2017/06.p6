#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines[0].comb(/\d+/).map: *.Int;
    my %seen;
    for ^Inf -> $cnt {
        return $cnt if $ex == 0 && defined %seen{~@arr};
        return $cnt - %seen{~@arr} if $ex == 1 && defined %seen{~@arr};
        %seen{~@arr} = $cnt;
        my ($idx, $val) = @arr.maxpairs[0].kv;
        @arr[$idx] = 0;
        for ^$val {
            $idx = ($idx + 1) % @arr;
            @arr[$idx]++;
        }
    }
}

is run('06.t1', 0), 5;
is run('06.t1', 1), 4;
done-testing;

say run('06.in', 0);
say run('06.in', 1);
