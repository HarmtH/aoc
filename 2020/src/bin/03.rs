#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> u32 {
    let map: Vec<&[u8]> = input
        .lines()
        .map(|l| l.as_bytes())
        .collect();

    let check = |right: usize, down: usize| {
        let mut sum = 0;
        let mut col = 0;
        for (idx, row) in map.iter().enumerate() {
            if idx % down != 0 { continue }
            if row[col] == b'#' { sum += 1 };
            col = (col + right) % row.len();
        }
        sum
    };

    match part {
        Part1 => {
            check(3, 1)
        }
        Part2 => {
            [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
                .iter()
                .map(|&(r, d)| check(r, d))
                .product()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/03.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "..##.......\n\
                      #...#...#..\n\
                      .#....#..#.\n\
                      ..#.#...#.#\n\
                      .#...##..#.\n\
                      ..#.##.....\n\
                      .#.#.#....#\n\
                      .#........#\n\
                      #.##...#...\n\
                      #...##....#\n\
                      .#..#...#.#\n";

        assert_eq!(solve(input1, Part1), 7);
        assert_eq!(solve(input1, Part2), 336);
    }
}
