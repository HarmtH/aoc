#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> usize {
    let re = regex::Regex::new(r"(?P<min>\d+)-(?P<max>\d+) (?P<char>.): (?P<passwd>.*)").unwrap();
    match part {
        Part1 => {
            input
                .lines()
                .map(|l| re.captures(l).unwrap())
                .filter( |m|
                    (m["min"].parse().unwrap() ..= m["max"].parse().unwrap())
                    .contains(&m["passwd"]
                        .matches(&m["char"])
                        .count()))
                .count()
        }
        Part2 => {
            input
                .lines()
                .map(|l| re.captures(l).unwrap())
                .filter( |m|
                    (m["passwd"].as_bytes()[m["min"].parse::<usize>().unwrap() - 1] == m["char"].as_bytes()[0]) ^
                    (m["passwd"].as_bytes()[m["max"].parse::<usize>().unwrap() - 1] == m["char"].as_bytes()[0]))
                .count()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/02.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "1-3 a: abcde\n\
                      1-3 b: cdefg\n\
                      2-9 c: ccccccccc\n";

        assert_eq!(solve(input1, Part1), 2);
        assert_eq!(solve(input1, Part2), 1);
    }
}
