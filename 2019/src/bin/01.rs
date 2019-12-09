#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> String {
    let masses: Vec<i32> = input
        .trim()
        .split('\n')
        .map(|num| num
             .parse()
             .unwrap_or_else(|err| panic!("{}: {}", err, num)))
        .collect();

    fn calc_fuel(mass: i32) -> i32 {
        mass / 3 - 2
    }

    fn calc_fuel_better(mass: i32) -> i32 {
        let fuel = calc_fuel(mass);
        if fuel > 0 { fuel + calc_fuel_better(fuel) } else { 0 }
    }

    match part {
        Part1 => {
            masses
                .into_iter()
                .map(calc_fuel)
                .sum::<i32>()
                .to_string()
        }
        Part2 => {
            masses
                .into_iter()
                .map(calc_fuel_better)
                .sum::<i32>()
                .to_string()
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
        let input1 = "12";
        let input2 = "14";
        let input3 = "1969";
        let input4 = "100756";

        assert_eq!(solve(input1, Part1), "2");
        assert_eq!(solve(input2, Part1), "2");
        assert_eq!(solve(input3, Part1), "654");
        assert_eq!(solve(input4, Part1), "33583");

        assert_eq!(solve(input1, Part2), "2");
        assert_eq!(solve(input2, Part2), "2");
        assert_eq!(solve(input3, Part2), "966");
        assert_eq!(solve(input4, Part2), "50346");
    }
}
