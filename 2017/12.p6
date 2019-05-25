#!/usr/bin/perl6

use v6.d;
use Test;

sub dfs($program, @arr, $seen, $component) {
    return if $seen{$program}++;
    $component{$program}++;
    dfs($_, @arr, $seen, $component) for @arr[$program]<>;
}

sub run($infile, $ex) {
    my @arr = [ [ .comb(/\d+/)[1..*]>>.Int ] for $infile.IO.lines ];
    my $seen = SetHash.new;
    my @components;
    for ^@arr -> $program {
        next if $seen{$program};
        my $component = SetHash.new;
        dfs($program, @arr, $seen, $component);
        @components.push($component);
    }
    if $ex == 0 {
        for @components -> $component {
            return +$component if $component{0};
        }
    } elsif $ex == 1 {
        +@components;
    }
}

is run('12.t1', 0), 6;
is run('12.t1', 1), 2;
done-testing;

say run('12.in', 0);
say run('12.in', 1);
