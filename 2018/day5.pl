#!/usr/bin/perl
use 5.026;
use List::UtilsBy qw(min_by);

my (@chars, %scores);
@chars = /(.)/g foreach <>;

foreach my $toDel (0, 'a'..'z') {
    my @curChars = grep {!/($toDel|\u$toDel)/} @chars;

    for (my $i = 0; $i < @curChars - 1; $i++) {
        if ($curChars[$i] eq ($curChars[$i + 1] ^ " ")) {
            splice @curChars, $i, 2;
            $i = $i ? $i - 2 : -1; } }

    say scalar @curChars unless $toDel;
    $scores{$toDel} = scalar @curChars; }

say min_by {$scores{$_}} keys %scores;
