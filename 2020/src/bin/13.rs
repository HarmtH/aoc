#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> usize {
    let mut it = input.lines();

    let earliest: usize = it.next().unwrap().parse().unwrap();

    let busids: Vec<Option<_>> = it
        .next()
        .unwrap()
        .split(',')
        .map(|id| id.parse().ok())
        .collect();

    match part {
        Part1 => {
            let ans = busids
                .iter()
                .filter_map(|id| *id)
                .map(|id| (id, id - earliest % id))
                .min_by_key(|x| x.1)
                .unwrap();
            ans.0 * ans.1
        }
        Part2 => {
            let ans = busids
                .iter()
                .enumerate()
                .filter(|(_idx, id)| id.is_some())
                .map(|(idx, id)| (idx, id.unwrap()))
                .fold((0, 1), |res, new| // (subans, lcm)
                    ((0..new.1)
                     .map(|i| (res.0 + i * res.1))
                     .find(|check| (check + new.0) % new.1 == 0).unwrap(),
                     res.1 * new.1));
            ans.0
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/13.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "939\n\
                      7,13,x,x,59,x,31,19\n";
        let input2 = "0\n\
                      17,x,13,19\n";

        assert_eq!(solve(input1, Part1), 295);
        assert_eq!(solve(input1, Part2), 1068781);
        assert_eq!(solve(input2, Part2), 3417);
    }
}
