#![warn(clippy::all)]

use aoc::*;
use std::collections::VecDeque;
use std::collections::HashSet;

fn solve(input: &str, part: Part) -> usize {
    let mut players: Vec<VecDeque<usize>> = input
        .trim()
        .split("\n\n")
        .map(|player_lines| player_lines
            .lines()
            .skip(1)
            .map(|num| num.parse().unwrap())
            .collect())
        .collect();

    match part {
        Part1 => {
            while !players.iter().any(|player| player.len() == 0) {
                let round_numbers: Vec<usize> = vec!(players[0].pop_front().unwrap(), players[1].pop_front().unwrap());
                let winner = if round_numbers[0] > round_numbers[1] { 0 } else { 1 };
                players[winner].push_back(round_numbers[winner]);
                players[winner].push_back(round_numbers[1 - winner]);
            }
            players[if players[0].len() > 0 { 0 } else { 1 }].iter().rev().enumerate().map(|(idx, num)| (1+idx)*num).sum()
        }
        Part2 => {
            let (winner, players) = do_game(players);
            players[winner].iter().rev().enumerate().map(|(idx, num)| (1+idx)*num).sum()
        }
    }
}

fn do_game(mut players: Vec<VecDeque<usize>>) -> (usize, Vec<VecDeque<usize>>)  {
    let mut seen: HashSet<Vec<VecDeque<usize>>> = HashSet::new();
    // let mut count = 0;
    while !players.iter().any(|player| player.len() == 0) {
        // if count > 500 {
        if !seen.insert(players.clone()) {
            return (0, players);
        }
        players = do_round(players);
        // count += 1;
    }
    (if players[0].len() > 0 { 0 } else { 1 }, players)
}

fn do_round(mut players: Vec<VecDeque<usize>>) -> Vec<VecDeque<usize>> {
    let round_numbers: Vec<usize> = vec!(players[0].pop_front().unwrap(), players[1].pop_front().unwrap());
    let winner;
    if players[0].len() >= round_numbers[0] && players[1].len() >= round_numbers[1] {
        winner = do_game(players
            .iter()
            .enumerate()
            .map(|(idx, player)| player
                .clone()
                .into_iter()
                .take(round_numbers[idx])
                .collect())
            .collect::<Vec<VecDeque<usize>>>()).0
    } else {
        winner = if round_numbers[0] > round_numbers[1] { 0 } else { 1 }
    }
    players[winner].push_back(round_numbers[winner]);
    players[winner].push_back(round_numbers[1 - winner]);
    players
}

fn main() {
    let input = std::fs::read_to_string("inputs/22.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "Player 1:\n\
                      9\n\
                      2\n\
                      6\n\
                      3\n\
                      1\n\
                      \n\
                      Player 2:\n\
                      5\n\
                      8\n\
                      4\n\
                      7\n\
                      10\n";

        assert_eq!(solve(input1, Part1), 306);
        assert_eq!(solve(input1, Part2), 291);
    }
}
