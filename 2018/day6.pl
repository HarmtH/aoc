#!/usr/bin/perl
use 5.026;
use List::Util qw(max);
use List::UtilsBy qw(min_by);
use List::MoreUtils qw(minmax);

my @coords;
push @coords, scalar {x => /\G(\d+)/, y => /, (\d+)/} foreach <>;

my ($minX, $maxX) = minmax map {$_->{x}} @coords;
my ($minY, $maxY) = minmax map {$_->{y}} @coords;

foreach my $x ($minX - 1 .. $maxX + 1) {
    foreach my $y ($minY - 1 .. $maxY + 1) {
        my @bestCoords = min_by {abs($_->{x} - $x) + abs($_->{y} - $y)} @coords;
        if (@bestCoords == 1) {
            if ($x >= $minX and $x <= $maxX and $y >= $minY and $y <= $maxY) {
                $bestCoords[0]->{score}++;
            } else {
                $bestCoords[0]->{score} = '-inf'; } } } }

say max map {$_->{score}} @coords;
