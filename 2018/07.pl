#!/usr/bin/perl
use 5.026;
use List::Util qw(all);
use Storable qw(dclone);

my %ls;

while (<>) {
    my ($parent, $child) = /\s(\S)\s/g;
    sub def {{state => 'blocked',
              timeleft =>(60 + (ord($_[0]) - ord('A') + 1))}};
    $ls{$parent} //= def $parent;
    $ls{$child} //= def $child;
    $ls{$child}{parents}{$parent} = $ls{$parent}; }

sub work {
    my $elves = shift;
    my ($seconds, @result);
    my %ls = %{dclone(\%ls)};

    while (!(all {$_->{state} eq 'done'} values %ls)) {
        foreach my $l (grep {$_->{state} eq 'blocked'} (values %ls)) {
            if (all {$_->{state} eq 'done'} (values $l->{parents}->%*)) {
                $l->{state} = 'waiting'; } }

        foreach my $l (grep {$_->{state} eq 'waiting'} (map {$ls{$_}} sort keys %ls)) {
            if ((grep {$_->{state} eq 'inprogress'} (values %ls)) < $elves) {
                $l->{state} = 'inprogress'; } }

        foreach my $l (grep {$_->{state} eq 'inprogress'} (values %ls)) {
            if (!--$l->{timeleft}) {
                $l->@{'state','time'} = ('done', $seconds); } }

        $seconds++; }

    return {seconds => $seconds,
            result => [sort {$ls{$a}{time} <=> $ls{$b}{time}} keys %ls]}; }

say work(1)->{result}->@*;
say work(5)->{seconds};
