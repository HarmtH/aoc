#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines[0].comb;
    my $ans = 0;
    for ^@arr -> $i {
        if $ex == 0 {
            $ans += @arr[$i] if @arr[$i] eq @arr[($i+1) % @arr];
        } elsif $ex == 1 {
            $ans += @arr[$i] if @arr[$i] eq @arr[($i+@arr/2) % @arr];
        }
    }
    $ans;
}

# is run('01.t1', 0), 3;
# is run('01.t2', 0), 4;
# is run('01.t3', 0), 0;
# is run('01.t4', 0), 9;
# is run('01.t5', 1), 6;
# is run('01.t6', 1), 0;
# is run('01.t7', 1), 4;
# is run('01.t8', 1), 12;
# is run('01.t9', 1), 4;
# done-testing;

say run('01.in', 0);
say run('01.in', 1);
