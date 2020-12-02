#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> <TYPE> {
    match part {
        Part1 => {
        }
        Part2 => {
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/_DAY_.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    // println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "";

        assert_eq!(solve(input1, Part1), <ANS>);
        // assert_eq!(solve(input1, Part2), <ANS>);
    }
}
