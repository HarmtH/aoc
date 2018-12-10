#!/usr/bin/perl
use 5.026;
use List::MoreUtils qw(minmax);

sub getstats {
    my %stats;
    @stats{qw(minX maxX)} = (minmax map {$_->{x}} $_[0]->@*);
    @stats{qw(minY maxY)} = (minmax map {$_->{y}} $_[0]->@*);
    $stats{size} = ($stats{maxX} - $stats{minX}) *
                   ($stats{maxY} - $stats{minY});
    return \%stats; }

my @curpoints;

while (<>) {
    my ($x, $y, $dx, $dy) = /(-?\d+)/g;
    push @curpoints, {x => $x, y => $y, dx => $dx, dy => $dy}; }

for (my $i;;$i++) {
    my @newpoints = map {{ x => $_->{x} + $_->{dx}, y => $_->{y} + $_->{dy},
                          dx => $_->{dx}, dy => $_->{dy}}} (@curpoints);

    my %newstats = %{getstats \@newpoints};
    my %curstats = %{getstats \@curpoints};

    if ($newstats{size} > $curstats{size}) {
        my %seen;
        @curpoints = grep {!$seen{$_->{x}, $_->{y}}++}
                    (sort {$a->{y} <=> $b->{y} or $a->{x} <=> $b->{x}}
                     @curpoints);
        my $prevpoint = {x => $curstats{minX} - 1, y => $curstats{minY}};
        foreach my $curpoint (@curpoints) {
            if ($prevpoint->{y} != $curpoint->{y}) {
                print "\n" x ($curpoint->{y} - $prevpoint->{y}) .
                       ' ' x ($curpoint->{x} - $curstats{minX}) . '#'; }
            else {
                print ' ' x ($curpoint->{x} - $prevpoint->{x} - 1) . '#'; }
            $prevpoint = $curpoint; }
        print "\n$i\n";
        last; }

    @curpoints = @newpoints; }
