#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> u32 {
    let entries: Vec<u32> = input
        .lines()
        .map(|num| num.parse().unwrap())
        .collect();

    match part {
        Part1 => {
            for i in 0 .. entries.len() {
                for j in (i + 1) .. entries.len() {
                    if entries[i] + entries[j] == 2020 {
                        return entries[i] * entries[j]
                    }
                }
            }
            panic!("No solution found")
        }
        Part2 => {
            for i in 0 .. entries.len() {
                for j in (i + 1) .. entries.len() {
                    for k in (j + 1) .. entries.len() {
                        if entries[i] + entries[j] + entries[k] == 2020 {
                            return entries[i] * entries[j] * entries[k]
                        }
                    }
                }
            }
            panic!("No solution found")
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/01.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "1721\n979\n366\n299\n675\n1456";

        assert_eq!(solve(input1, Part1), 514579);
        assert_eq!(solve(input1, Part2), 241861950);
    }
}
