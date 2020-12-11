#![warn(clippy::all)]

use aoc::*;

fn solve(input: &str, part: Part) -> usize {
    let map: Vec<Vec<u8>> = input
        .lines()
        .map(|l| l.as_bytes().to_vec())
        .collect();

    fn check_dir(y: i8, x: i8, dy: i8, dx: i8, map: &Vec<Vec<u8>>, recurse: bool) -> u8 {
        let newy = y + dy;
        let newx = x + dx;
        if newx < 0 || newx >= map[0].len() as i8 || newy < 0 || newy >= map.len() as i8 { return b'x' }
        match map[newy as usize][newx as usize] {
            b'.' => if recurse { check_dir(newy, newx, dy, dx, map, recurse) } else { b'.' },
            x    => x
        }
    }

    fn count_around(y: usize, x: usize, map: &Vec<Vec<u8>>, recurse: bool) -> u8 {
        [(-1,-1), (-1, 0), (-1, 1),
         ( 0,-1),          ( 0, 1),
         ( 1,-1), ( 1, 0), ( 1, 1)]
                .iter()
                .map(|(dy, dx)| check_dir(y as i8, x as i8, *dy, *dx, map, recurse))
                .filter(|&found| found == b'#')
                .count() as u8
    }

    fn calc(mut map: Vec<Vec<u8>>, toggle: u8, recurse: bool) -> usize {
        let mut sum = 0;
        loop {
            let prevsum = sum;
            let prevmap = map.clone();
            sum = 0;
            for y in 0..map.len() {
                for x in 0..map[0].len() {
                    match map[y][x] {
                        b'L' => if count_around(y, x, &prevmap, recurse) == 0 { map[y][x] = b'#' },
                        b'#' => if count_around(y, x, &prevmap, recurse) >= toggle { map[y][x] = b'L' },
                        _    => ()
                    }
                    if map[y][x] == b'#' { sum += 1 }
                }
            }
            if sum == prevsum { return sum; };
        }
    }

    match part {
        Part1 => {
            calc(map, 4, false)
        }
        Part2 => {
            calc(map, 5, true)
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/11.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "L.LL.LL.LL\n\
                      LLLLLLL.LL\n\
                      L.L.L..L..\n\
                      LLLL.LL.LL\n\
                      L.LL.LL.LL\n\
                      L.LLLLL.LL\n\
                      ..L.L.....\n\
                      LLLLLLLLLL\n\
                      L.LLLLLL.L\n\
                      L.LLLLL.LL\n";

        assert_eq!(solve(input1, Part1), 37);
        assert_eq!(solve(input1, Part2), 26);
    }
}
