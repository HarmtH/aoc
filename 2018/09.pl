#!/usr/bin/perl
use 5.026;
use List::Util qw(max);
use Test::More;

sub calculate {
    my ($players, $highest, $factor) = @_;
    my (@players, $curplayer);

    # linked list: [data, prev, next]
    my $node = [];
    $node->[0] = 0;
    $node->[1] = $node;
    $node->[2] = $node;

    for my $marble (1 .. ($factor * $highest)) {
        if ($marble % 23) {
            $node = $node->[2];
            my $newnode = [$marble, $node, $node->[2]];
            $node->[2]->[1] = $newnode;
            $node->[2] = $newnode;
            $node = $newnode; }
        else {
            $players[$curplayer] += $marble;
            $node = $node->[1] foreach 1..7;
            $players[$curplayer] += $node->[0];
            $node->[1]->[2] = $node->[2];
            $node->[2]->[1] = $node->[1];
            $node = $node->[2]; }
        $curplayer = ($curplayer + 1) % $players; }

    return max @players; }

is calculate(9, 25, 1), 32;
is calculate(10, 1618, 1), 8317;
is calculate(13, 7999, 1), 146373;
done_testing;

say calculate(452, 70784, 1);
say calculate(452, 70784, 100);
