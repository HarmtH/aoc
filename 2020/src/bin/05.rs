#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;

fn decode_pass(pass: &str) -> u32 {
    let bin_str = pass
        .replace("F", "0")
        .replace("B", "1")
        .replace("L", "0")
        .replace("R", "1");

    u32::from_str_radix(&bin_str, 2).unwrap()
}

fn solve(input: &str, part: Part) -> u32 {

    let seatids: Vec<u32> = input
        .lines()
        .map(decode_pass)
        .sorted()
        .collect();

    match part {
        Part1 => {
            seatids[seatids.len() - 1]
        }
        Part2 => {
            seatids
                .windows(2)
                .find(|win| win[0] + 2 == win[1])
                .unwrap()[0] + 1
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/05.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_decode_pass() {
        let input1 = "BFFFBBFRRR";
        let input2 = "FFFBBBFRRR";
        let input3 = "BBFFBBFRLL";

        assert_eq!(decode_pass(input1), 567);
        assert_eq!(decode_pass(input2), 119);
        assert_eq!(decode_pass(input3), 820);
    }

    #[test]
    fn test_solve() {
        let input1 = "BFFFBBFRRR\n\
                      FFFBBBFRRR\n\
                      BBFFBBFRLL\n";

        assert_eq!(solve(input1, Part1), 820);
    }
}
