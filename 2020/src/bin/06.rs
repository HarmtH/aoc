#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;
use std::collections::HashSet;

fn solve(input: &str, part: Part) -> usize {
    match part {
        Part1 => {
            input
                .trim()
                .split("\n\n")
                .map(|group: &str| group
                    .split("\n")
                    .map(|person: &str| person
                        .chars()
                        .collect::<HashSet<_>>())
                    .tree_fold1(|p1, p2| (&p1 | &p2))
                    .unwrap()
                    .len())
                .sum()
        }
        Part2 => {
            input
                .trim()
                .split("\n\n")
                .map(|group: &str| group
                    .split("\n")
                    .map(|person: &str| person
                        .chars()
                        .collect::<HashSet<_>>())
                    .tree_fold1(|p1, p2| (&p1 & &p2))
                    .unwrap()
                    .len())
                .sum()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/06.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "abc\n\
                      \n\
                      a\n\
                      b\n\
                      c\n\
                      \n\
                      ab\n\
                      ac\n\
                      \n\
                      a\n\
                      a\n\
                      a\n\
                      a\n\
                      \n\
                      b\n";

        assert_eq!(solve(input1, Part1), 11);
        assert_eq!(solve(input1, Part2), 6);
    }
}
