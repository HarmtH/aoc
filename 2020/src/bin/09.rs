#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;

static mut W: usize = 25;

fn solve(input: &str, part: Part) -> u64 {
    let numbers: Vec<u64> = input
        .lines()
        .map(|l| l.parse().unwrap())
        .collect();

    match part {
        Part1 => {
            let window = unsafe { W };
            numbers
                .windows(window + 1)
                .find(|win| win[0..window]
                    .iter()
                    .permutations(2)
                    .all(|perm| perm.iter().copied().sum::<u64>() != win[window]))
                .unwrap()[window]
        }
        Part2 => {
            let ans = solve(input, Part1);
            for len in 2..numbers.len() {
                for win in numbers.windows(len) {
                    if win.iter().sum::<u64>() == ans {
                        return win.iter().min().unwrap() + win.iter().max().unwrap();
                    }
                }
            }
            panic!("no solution found")
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/09.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "35\n\
                      20\n\
                      15\n\
                      25\n\
                      47\n\
                      40\n\
                      62\n\
                      55\n\
                      65\n\
                      95\n\
                      102\n\
                      117\n\
                      150\n\
                      182\n\
                      127\n\
                      219\n\
                      299\n\
                      277\n\
                      309\n\
                      576\n";

        unsafe { W = 5 };
        assert_eq!(solve(input1, Part1), 127);
        assert_eq!(solve(input1, Part2), 62);
    }
}
