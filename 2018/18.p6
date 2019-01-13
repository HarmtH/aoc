#!/usr/bin/perl6

use v6.d;
use Test;

sub get-adjacent(@grid, ($cy, $cx)) {
    my @results;
    for (-1, 0, 1) X (-1, 0, 1) -> ($dy, $dx) {
        next if ($dy, $dx) eqv (0, 0);
        my ($y, $x) = ($cy + $dy, $cx + $dx);
        next if !($y >= 0 && $y < @grid.elems && $x >= 0 && $x < @grid[0].elems);
        @results.push(@grid[$y;$x]);
    }
    @results;
}

sub new-day(@grid) {
    my @new-grid;
    for (0..^@grid.elems) X (0..^@grid[0].elems) -> ($y, $x) {
        my $adj = get-adjacent(@grid, ($y,$x));
        given @grid[$y;$x] {
            when $_ eq '.' && $adj.grep('|') >= 3 { @new-grid[$y;$x] = '|' }
            when $_ eq '|' && $adj.grep('#') >= 3 { @new-grid[$y;$x] = '#' }
            when $_ eq '#' && (('#', '|') ⊈ $adj) { @new-grid[$y;$x] = '.' }
            default { @new-grid[$y;$x] = $_; }
        }
    }
    @new-grid;
}

sub calculate($in, $runs) {
    my @grid.push($_.comb) for $in.IO.lines;
    for 1..$runs -> $run {
        @grid = new-day(@grid);
        say "$run) " ~ @grid[*;*].grep('|') * @grid[*;*].grep('#');
    }
    return @grid[*;*].grep('|') * @grid[*;*].grep('#');
}

is calculate('18.t1', 10), 1147;
done-testing;

say "ans1: " ~ calculate('18.in', 10);
say "ans2: " ~ calculate('18.in', 1e9);
