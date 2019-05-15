#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = [ .split(' ') for $infile.IO.lines ];
    my %regs is default(0);
    my $ans2 = 0;
    for @arr -> ($reg, $op, $val, $if, $cmpreg, $cmpop, $cmpval) {
        with $cmpop {
            when '>' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} > $cmpval }
            when '>=' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} >= $cmpval }
            when '<' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} < $cmpval }
            when '<=' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} <= $cmpval }
            when '==' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} == $cmpval }
            when '!=' { %regs{$reg} = %regs{$reg} + ($op eq 'inc' ?? 1 !! -1) * $val if %regs{$cmpreg} != $cmpval }
        }
        $ans2 = max($ans2, %regs.values.max);
    }
    if $ex == 0 {
        return %regs.values.max;
    } elsif $ex == 1 {
        return $ans2;
    }
}

is run('08.t1', 0), 1;
is run('08.t1', 1), 10;
done-testing;

say run('08.in', 0);
say run('08.in', 1);
