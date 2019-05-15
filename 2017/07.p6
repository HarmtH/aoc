#!/usr/bin/perl6

use v6.d;
use Test;

role Done {};

sub recurse(%program where { $_ ~~ Pair } ) returns Int {
    # create map: %( childscore => [ childname => childdata ] )
    my %scores;
    for %program.value{'children'}<> -> %childprogram {
        my $res = recurse(%childprogram);
        # if a child has the answer just return it
        return $res if $res ~~ Done;
        %scores{$res}.push(%childprogram);
    }

    # search for a unique and normal child score
    my $us = %scores.grep(*.value == 1).head;
    my $ns = %scores.grep(*.value > 1).head;

    if $us {
        # if unique score is found, return the answer
        return ($us.value.head.value{'score'} + ($ns.key - $us.key)) but Done;
    } else {
        # otherwise, return leaves total score
        return %program.value{'score'} + ({$ns.key * $ns.value} if $ns);
    }
}

sub run($infile, $ex) {
    my %programs;
    for $infile.IO.lines -> $line {
        my ($prog, $score, @children) = $line.comb(/\w+/);
        %programs{$prog}{'score'} = $score.Int;
        (%programs{$_} //= %()) for @children;
        %programs{$prog}{'children'} = ((%programs{$_}:p) for @children);
        (%programs{$_}{'has-parent'} = True) for @children;
    }
    my %rootprog := $_ unless .value{'has-parent'} for %programs;
    return %rootprog.key if $ex == 0;
    return recurse(%rootprog);
}

is run('07.t1', 0), 'tknk';
is run('07.t1', 1), 60;
done-testing;

say run('07.in', 0);
say run('07.in', 1);
