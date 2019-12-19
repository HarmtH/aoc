#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> String {
    let mut machine: IntCodeEmulator = input.into();

    match part {
        Part1 => {
            for y in 0..50 {
                for x in 0..50 {
                    machine.input.push_back(x);
                    machine.input.push_back(y);
                    machine.run_to_halt();
                    machine.reset_program();
                }
            }
            machine.output.into_iter().filter(|&v| v == 1).count().to_string()
        }
        Part2 => {
            let mut x_start = 0;

            for y in 99.. {
                for x in x_start.. {
                    machine.input.push_back(x);
                    machine.input.push_back(y);
                    machine.run_to_halt();
                    machine.reset_program();
                    if machine.output.pop_front().unwrap() == 1 {
                        machine.input.push_back(x + 99);
                        machine.input.push_back(y - 99);
                        machine.run_to_halt();
                        machine.reset_program();
                        if machine.output.pop_front().unwrap() == 1 {
                            return ((x * 10_000) + y - 99).to_string()
                        }
                        x_start = x;
                        break;
                    }
                }
            }
            unreachable!()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/19.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}
