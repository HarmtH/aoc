#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> String {
    let mut machine: IntCodeEmulator = input.into();

    match part {
        Part1 => {
            machine.input.push_back(1);
            machine.run_to_halt();
            machine.output.pop_front().expect("No output").to_string()
        }
        Part2 => {
            machine.input.push_back(5);
            machine.run_to_halt();
            machine.output.pop_front().expect("No output").to_string()
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
    fn test_part1() {
        let input = "1002,4,3,4,33";
        let mut machine: IntCodeEmulator = input.into();
        machine.run_to_halt();

        assert_eq!(machine.program[4], 99);
    }

    #[test]
    fn test_part2() {
        let input = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,\
            0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,\
            1000,1,20,4,20,1105,1,46,98,99";

        let mut machine: IntCodeEmulator = input.into();
        machine.input.push_back(6);
        machine.run_to_halt();
        assert_eq!(machine.output.pop_front().expect("No output"), 999);

        machine.reset_all();
        machine.input.push_back(7);
        machine.run_to_halt();
        assert_eq!(machine.output.pop_front().expect("No output"), 999);

        machine.reset_all();
        machine.input.push_back(8);
        machine.run_to_halt();
        assert_eq!(machine.output.pop_front().expect("No output"), 1000);

        machine.reset_all();
        machine.input.push_back(9);
        machine.run_to_halt();
        assert_eq!(machine.output.pop_front().expect("No output"), 1001);

        machine.reset_all();
        machine.input.push_back(10);
        machine.run_to_halt();
        assert_eq!(machine.output.pop_front().expect("No output"), 1001);
    }
}
