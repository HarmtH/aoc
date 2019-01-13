#!/usr/bin/perl6

use v6.d;
use Test;

sub eff-power(%army) {
    %army{'units'} * %army{'admg'};
}

sub real-eff-power(%attacker, %defender) {
    (%attacker{'atype'} ∈ %defender{'weakto'} ?? 2 !! 1) * eff-power(%attacker);
}

sub select-sort(@army) {
    @army.sort({(eff-power($_), $_{'initiative'})}).reverse;
}

sub attack-sort(@army) {
    @army.sort({$_{'initiative'}}).reverse;
}

sub get-valid-enemies(%ally, @enemies) {
    @enemies.grep({!$_{'marked'} && (%ally{'atype'} ∉ $_{'immuneto'})})
}

sub parsearmy(@lines, $boost, $side) {
    @lines.shift;
    my @armies;
    while @lines && (my $line = @lines.shift) {
        my %army;
        %army{'side'} = $side;
        %army{'units'} = ($line ~~ /(\d+)' units'/)[0].Int;
        %army{'hp'} = ($line ~~ /(\d+)' hit points'/)[0].Int;
        my $weak = ($line ~~ /'weak to '[(\w+)<[,\ ]>*]*/);
        %army{'weakto'} = $weak ?? $weak[0].map(*.Str).list !! ();
        my $immune = ($line ~~ /'immune to '[(\w+)<[,\ ]>*]*/);
        %army{'immuneto'} = $immune ?? $immune[0].map(*.Str).list !! ();
        (%army{'admg'}, %army{'atype'}) = ($line ~~ /(\d+)' '(\w+)' damage'/).map(*.Str);
        %army{'admg'} += $boost;
        %army{'initiative'} = ($line ~~ /'initiative '(\d+)/)[0].Int;
        @armies.push(%army);
    }
    return @armies;
}

sub target-selection(@allies, @enemies) {
    for select-sort(@allies) -> %ally {
        if my @valid-enemies = get-valid-enemies(%ally, @enemies) {
            %ally{'target'} = select-sort(@valid-enemies).max({real-eff-power(%ally, $_)});
            %ally{'target'}{'marked'} = True;
        }
    }
}

sub attack(*@armies) {
    for attack-sort(@armies) -> $army {
        my $target := $army{'target'};
        next if !$target || $army{'units'} <= 0;
        $target{'units'} -= (real-eff-power($army, $target) div $target{'hp'});
    }
}

sub clean-up(@armies) {
    @armies .= grep(*{'units'} > 0);
    $_{'target'}:delete for @armies;
    $_{'marked'} = False for @armies;
}

sub is-game-over(@immsys, @infec) {
    my $winner = @immsys if !@infec;
    $winner = @infec if !@immsys;
    if $winner {
        my $units-left = [+] $winner.map(*{'units'});
        return ($winner[0]{'side'}, $units-left);
    }
    return False;
}

sub calculate($in, $boost = 0) {
    my @lines = $in.IO.lines;
    my @immune-armies = parsearmy(@lines, $boost, "Immune System");
    my @infection-armies = parsearmy(@lines, 0, "Infections");
    my $res;
    while !($res = is-game-over(@immune-armies, @infection-armies)) {
        target-selection(@immune-armies, @infection-armies);
        target-selection(@infection-armies, @immune-armies);
        attack(@immune-armies, @infection-armies);
        clean-up(@infection-armies);
        clean-up(@immune-armies);
    }
    return $res;
}

is (calculate('24.t1'))[1], 5216;
is (calculate('24.t1', 1570))[1], 51;
done-testing;

say calculate('24.in');
say calculate('24.in', @*ARGS[0] // 57);
