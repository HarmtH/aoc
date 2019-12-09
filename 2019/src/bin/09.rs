#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> i64 {
    let mut machine: IntCodeEmulator = input.into();

    match part {
        Part1 => {
            machine.input.push_back(1);
            machine.run_to_halt();
            machine.output.pop_front().unwrap()
        }
        Part2 => {
            machine.input.push_back(2);
            machine.run_to_halt();
            machine.output.pop_front().unwrap()
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
        let input11 = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99";
        let input12 = "1102,34915192,34915192,7,4,7,99,0";
        let input13 = "104,1125899906842624,99";

        let mut machine: IntCodeEmulator = input11.into();
        machine.run_to_halt();
        assert_eq!(machine.output.iter().map(|c| c.to_string()).collect::<Vec<String>>().join(","), input11);

        let mut machine: IntCodeEmulator = input12.into();
        machine.run_to_halt();
        assert_eq!(machine.output[0], 34_915_192*34_915_192);

        let mut machine: IntCodeEmulator = input13.into();
        machine.run_to_halt();
        assert_eq!(machine.output[0], 1_125_899_906_842_624);
    }
}
