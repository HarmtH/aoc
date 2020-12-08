#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;
use std::collections::HashSet;

fn solve(input: &str, part: Part) -> i32 {
    let program: Vec<(&str, i32)> = input
        .lines()
        .map(|l| l
            .split(" ")
            .collect_tuple()
            .unwrap())
        .map(|(op, arg)| (op, arg.parse().unwrap()))
        .collect();

    match part {
        Part1 => {
            let mut ip = 0;
            let mut acc = 0;
            let mut seen = HashSet::new();

            while seen.insert(ip) {
                let (op, arg) = program[ip as usize];
                match op {
                    "nop" => ip += 1,
                    "acc" => {acc += arg; ip +=1},
                    "jmp" => ip = (ip as i32 + arg) as usize,
                    _     => panic!("unknown instruction"),
                }
                assert!(ip as i32 >= 0);
            }

            acc
        }
        Part2 => {
            for i in 0..program.len() {
                let mut ip = 0;
                let mut acc = 0;
                let mut seen = HashSet::new();

                while seen.insert(ip) {
                    let (mut op, arg) = program[ip];
                    if ip == i && op == "jmp" {
                        op = "nop"
                    } else if ip == i && op == "nop" {
                        op = "jmp"
                    }
                    match op {
                        "nop"  => ip += 1,
                        "acc"  => {acc += arg; ip += 1},
                        "jmp"  => ip = (ip as i32 + arg) as usize,
                        _      => panic!("unknown instruction"),
                    }
                    assert!(ip as i32 >= 0);
                    if ip >= program.len() { return acc }
                }
            }
            panic!("no answer found")
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/08.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "nop +0\n\
                      acc +1\n\
                      jmp +4\n\
                      acc +3\n\
                      jmp -3\n\
                      acc -99\n\
                      acc +1\n\
                      jmp -4\n\
                      acc +6\n";

        assert_eq!(solve(input1, Part1), 5);
        assert_eq!(solve(input1, Part2), 8);
    }
}
