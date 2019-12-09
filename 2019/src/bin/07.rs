#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;

fn solve(machine_str: &str, part: Part) -> i64 {
    let mut solution = None;
    let mut machines: Vec<IntCodeEmulator> =
        std::iter::repeat(machine_str.into()).take(5).collect();

    for settings in (if part == Part1 { (0..5) } else { 5..10 }).permutations(5) {
        // println!("Trying: {:?}", settings);

        // Configure chain
        for (machine, setting) in machines.iter_mut().zip(settings.into_iter()) {
            machine.reset_all();
            machine.input.push_back(setting);
        }

        // Run the chain
        let mut output = Some(0);
        while !machines.iter().all(|machine| machine.is_halted()) {
            for machine in machines.iter_mut() {
                if let Some(output) = output { machine.input.push_back(output) };
                machine.run_to_interrupt_list(&[Interrupt::InputRequested, Interrupt::Halted]);
                output = machine.output.pop_front();
            }
        }
        solution = std::cmp::max(solution, machines[4].last_out);
    }

    solution.expect("No solution found")
}

fn main() {
    let input = std::fs::read_to_string("inputs/07.in").unwrap();
    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input11 = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0";
        let input12 = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,\
                       23,23,4,23,99,0,0";
        let input13 = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,\
                       1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0";

        let input21 = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,\
                       1001,28,-1,28,1005,28,6,99,0,0,5";
        let input22 = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,\
                       55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,\
                       1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,\
                       99,0,0,0,0,10";

        assert_eq!(solve(input11, Part1), 43210);
        assert_eq!(solve(input12, Part1), 54321);
        assert_eq!(solve(input13, Part1), 65210);

        assert_eq!(solve(input21, Part2), 139_629_729);
        assert_eq!(solve(input22, Part2), 18216);
    }
}
