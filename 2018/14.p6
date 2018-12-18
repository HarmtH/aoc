#!/usr/bin/perl6

use v6.d;
use Test;

sub calculate(@score) {
    my @data = [3,7];
    my @elf = [0,1];
    while (True) {
        for ([+] @data[@elf]).Str.comb(/./) {
            @data.push($_.Int);
            return @data.elems - @score.elems if @data.elems >= @score.elems and @data[*-@score.elems .. *] eqv @score;
        }
        @elf = @elf.map({($_ + 1 + @data[$_]) % @data.elems});
    }
}

is calculate((5,1,5,8,9)), 9;
is calculate((0,1,2,4,5)), 5;
is calculate((9,2,5,1,0)), 18;
is calculate((5,9,4,1,4)), 2018;
done-testing;

say calculate((8,2,4,5,0,1));
