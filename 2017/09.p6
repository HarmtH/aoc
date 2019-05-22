#!/usr/bin/perl6

use v6.d;
use Test;

sub run($infile, $ex) {
    my @arr = $infile.IO.lines[0].comb;
    my $skip-next = False;
    my $in-garbage = False;
    my $nest-level = 0;
    my @ans = (0,0);
    for @arr -> $char {
        when $skip-next { $skip-next = False }
        when $char eq '!' &&  $in-garbage { $skip-next = True }
        when $char eq '<' && !$in-garbage { $in-garbage = True }
        when $char eq '>' &&  $in-garbage { $in-garbage = False }
        when $char eq '{' && !$in-garbage { @ans[0] += ++$nest-level }
        when $char eq '}' && !$in-garbage { $nest-level-- }
        when $in-garbage { @ans[1]++ }
    }
    @ans[$ex];
}

is run('09.t1', 0), 1;
is run('09.t2', 0), 6;
is run('09.t3', 0), 5;
is run('09.t4', 0), 16;
is run('09.t5', 0), 1;
is run('09.t6', 0), 9;
is run('09.t7', 0), 9;
is run('09.t8', 0), 3;
is run('09.t9', 1), 0;
is run('09.t10', 1), 17;
is run('09.t11', 1), 3;
is run('09.t12', 1), 2;
is run('09.t13', 1), 0;
is run('09.t14', 1), 0;
is run('09.t15', 1), 10;
done-testing;

say run('09.in', 0);
say run('09.in', 1);
