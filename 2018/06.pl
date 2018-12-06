#!/usr/bin/perl
use 5.026;
use List::Util qw(max sum);
use List::UtilsBy qw(min_by);
use List::MoreUtils qw(minmax);

my (@coords, $nearAll);
push @coords, scalar {x => /\G(\d+)/, y => /, (\d+)/} foreach <>;

my ($minX, $maxX) = minmax map {$_->{x}} @coords;
my ($minY, $maxY) = minmax map {$_->{y}} @coords;

foreach my $x ($minX..$maxX) {
    foreach my $y ($minY..$maxY) {
        my $score = sub {abs($_[0]->{x} - $x) + abs($_[0]->{y} - $y);};
        my $normal = sub {$x > $minX and $x < $maxX and $y > $minY and $y < $maxY;};

        my @bestCoords = min_by {$score->($_)} @coords;
        $bestCoords[0]->{score} = $normal->()
                                ? $bestCoords[0]->{score} + 1
                                : '-inf'
                                if @bestCoords == 1;

        $nearAll++ if sum(map {$score->($_)} @coords) < 10000 } };

say max map {$_->{score}} @coords;
say $nearAll;
