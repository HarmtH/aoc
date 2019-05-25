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

sub dense-hash($string) {
    my @lengths = $string.comb>>.ord;
    @lengths.append(17, 31, 73, 47, 23);
    my @sparse-hash = do-rounds([^256], @lengths, 64);
    my @dense-hash = @sparse-hash.rotor(16)>>.reduce(&[+^]);
    @dense-hash.map({"%08b".sprintf($_)}).join;
}

sub dfs($x, $y, @grid) {
    @grid[$x;$y] = 2;
    for ((0,1),(1,0),(0,-1),(-1,0)) -> ($dx, $dy) {
        my $nx = $x + $dx;
        my $ny = $y + $dy;
        if (0 <= $nx < 128) && (0 <= $ny < 128) && @grid[$nx;$ny] == 1 {
            dfs($nx, $ny, @grid)
        }
    }
}

sub run($infile, $ex) {
    my $string = $infile.IO.lines[0];
    my @grid;
    my @ans = (0,0);
    for ^128 -> $num {
        @grid[$num] = [ dense-hash($string ~ "-$num").comb>>.Int ];
        @ans[0] += @grid[$num].sum;
    }
    for ^128 X ^128 -> ($x, $y) {
        if @grid[$x;$y] == 1 {
            @ans[1]++;
            dfs($x, $y, @grid);
        }
    }
    @ans[$ex];
}

is run('14.t1', 0), 8108;
is run('14.t1', 1), 1242;
done-testing;

say run('14.in', 0);
say run('14.in', 1);
