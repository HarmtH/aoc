#!/usr/bin/perl6

use v6.d;
use Test;

sub do-rounds(@list, @lengths, $rounds) {
    my $curpos = 0;
    my $ss = 0; # skip size
    for ^$rounds {
        for @lengths -> $length {
            my $endpos = ($curpos + $length) % @list;
            my @shape = ($curpos + $length) >= @list
                ?? ($curpos ..^ @list, ^$endpos).flat
                !! $curpos ..^ $endpos;
            @list[@shape] .= reverse;
            $curpos = ($endpos + $ss) % @list;
            $ss++;
        }
    }
    @list;
}

sub run($infile, $ll, $ex) {
    my @list = ^$ll;
    if $ex == 0 {
        my @lengths = $infile.IO.lines[0].comb(/\d+/)>>.Int;
        @list = do-rounds(@list, @lengths, 1);
        @list[0] * @list[1];
    } elsif $ex == 1 {
        my @lengths = $infile.IO.lines[0].comb>>.ord;
        @lengths.append(17, 31, 73, 47, 23);
        my @sparse-hash = do-rounds(@list, @lengths, 64);
        my @dense-hash = @sparse-hash.rotor(16)>>.reduce(&[+^]);
        @dense-hash.map(*.fmt("%02x")).join;
    }
}

is run('10.t1', 5, 0), 12;
is run('10.t2', 256, 1), "a2582a3a0e66e6e86e3812dcb672a272";
is run('10.t3', 256, 1), "33efeb34ea91902bb2f59c9920caa6cd";
is run('10.t4', 256, 1), "3efbe78a8d82f29979031a4aa0b16a9d";
is run('10.t5', 256, 1), "63960835bcdc130f0b66d7ff4f6a5a8e";
done-testing;

say run('10.in', 256, 0);
say run('10.in', 256, 1);
