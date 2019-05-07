#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my $in = $infile.IO.lines[0];
    if $ex == 0 {
        my @pos = (0,0);
        my $cursquare = 1;
        my $stepsize = 1;
        for ^Inf {
            for (((1,0),0), ((0,1),1), ((-1,0),0), ((0,-1),1)) -> (@dpos, $step) {
                my $inc = min($stepsize, $in - $cursquare);
                @pos <<+=>> (@dpos <<*>> $inc);
                $cursquare += $inc;
                return @pos[0].abs + @pos[1].abs if $cursquare == $in;
                $stepsize += $step;
            }
        }
    } elsif $ex == 1 {
        my %grid is default(0);
        my @pos = (0,0);
        %grid{~@pos} = 1;
        my $stepsize = 1;
        for ^Inf {
            for (((1,0),0), ((0,1),1), ((-1,0),0), ((0,-1),1)) -> (@dpos, $step) {
                for ^$stepsize {
                    @pos <<+=>> @dpos;
                    my $val = ((-1,0,1)X(-1,0,1)).map({%grid{~(@pos <<+>> $_)}}).sum;
                    return $val if $val > $in;
                    %grid{~@pos} = $val;
                }
                $stepsize += $step;
            }
        }
    }
}

is run('03.t1', 0), 0;
is run('03.t2', 0), 3;
is run('03.t3', 0), 2;
is run('03.t4', 0), 31;
done-testing;

say run('03.in', 0);
say run('03.in', 1);
