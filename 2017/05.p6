#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines.map: *.Int;
    my $ip = 0;
    for ^Inf -> $ans {
        return $ans if not defined @arr[$ip];
        if $ex == 0 {
            $ip += @arr[$ip]++;
        } elsif $ex == 1 {
            my $off = @arr[$ip];
            @arr[$ip] += $off >= 3 ?? -1 !! 1;
            $ip += $off;
        }
    }
}

is run('05.t1', 0), 5;
is run('05.t1', 1), 10;
done-testing;

say run('05.in', 0);
say run('05.in', 1);
