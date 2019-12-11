#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;
use std::collections::BTreeMap;

fn solve(input: &str, part: Part) -> String {
    let asteroid_map: Vec<Point> = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| { line
            .bytes()
            .enumerate()
            .filter(|&(_x, chr)| chr == b'#')
            .map(move |(x, _chr)| Point{x: x as i16, y: y as i16})})
        .collect();

    let (best_asteroid_idx, most_seen) = asteroid_map
        .iter()
        .map(|asteroid| asteroid_map
             .iter()
             .filter(|&other| other != asteroid)
             .unique_by(|&&other| asteroid.xy_angle(other))
             .count())
        .enumerate()
        .max_by_key(|(_idx, cnt)| *cnt)
        .unwrap();

    match part {
        Part1 => {
            most_seen.to_string()
        }
        Part2 => {
            let best_asteroid = asteroid_map[best_asteroid_idx];

            let mut angle_to_offsets: BTreeMap<i32, Vec<Point>> = BTreeMap::new();

            for other_asteroid in asteroid_map {
                if other_asteroid == best_asteroid { continue }
                let mut angle = best_asteroid.rad_angle(other_asteroid);
                { use std::f64::consts::PI; if angle < -PI/2. { angle += 2.*PI } }
                let offset = other_asteroid - best_asteroid;
                angle_to_offsets.entry((1000. * angle) as i32).or_default().push(offset);
            }

            for offsets in angle_to_offsets.values_mut() {
                offsets.sort_by_key(|k| -(k.dist() as i16));
            }

            let mut shooting_order = Vec::new();

            while !angle_to_offsets.is_empty() {
                let mut empty_angles = Vec::new();
                for (angle, offsets) in angle_to_offsets.iter_mut() {
                    if let Some(killit_offset) = offsets.pop() {
                        shooting_order.push(best_asteroid + killit_offset);
                    } else {
                        empty_angles.push(*angle);
                    }
                }
                while let Some(angle) = empty_angles.pop() {
                    angle_to_offsets.remove(&angle);
                }

            }

            (shooting_order[199].x * 100 + shooting_order[199].y).to_string()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/10.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input11 = ".#..#\n\
                       .....\n\
                       #####\n\
                       ....#\n\
                       ...##";

        let input12 = "......#.#.\n\
                       #..#.#....\n\
                       ..#######.\n\
                       .#.#.###..\n\
                       .#..#.....\n\
                       ..#....#.#\n\
                       #..#....#.\n\
                       .##.#..###\n\
                       ##...#..#.\n\
                       .#....####";

        let input13 = "#.#...#.#.\n\
                       .###....#.\n\
                       .#....#...\n\
                       ##.#.#.#.#\n\
                       ....#.#.#.\n\
                       .##..###.#\n\
                       ..#...##..\n\
                       ..##....##\n\
                       ......#...\n\
                       .####.###.";

        let input14 = ".#..#..###\n\
                       ####.###.#\n\
                       ....###.#.\n\
                       ..###.##.#\n\
                       ##.##.#.#.\n\
                       ....###..#\n\
                       ..#.#..#.#\n\
                       #..#.#.###\n\
                       .##...##.#\n\
                       .....#.#..";

        let input15 = ".#..##.###...#######\n\
                       ##.############..##.\n\
                       .#.######.########.#\n\
                       .###.#######.####.#.\n\
                       #####.##.#.##.###.##\n\
                       ..#####..#.#########\n\
                       ####################\n\
                       #.####....###.#.#.##\n\
                       ##.#################\n\
                       #####.##.###..####..\n\
                       ..######..##.#######\n\
                       ####.##.####...##..#\n\
                       .#####..#.######.###\n\
                       ##...#.##########...\n\
                       #.##########.#######\n\
                       .####.#.###.###.#.##\n\
                       ....##.##.###..#####\n\
                       .#.#.###########.###\n\
                       #.#.#.#####.####.###\n\
                       ###.##.####.##.#..##";

        assert_eq!(solve(input11, Part1), "8");
        assert_eq!(solve(input12, Part1), "33");
        assert_eq!(solve(input13, Part1), "35");
        assert_eq!(solve(input14, Part1), "41");
        assert_eq!(solve(input15, Part1), "210");
        assert_eq!(solve(input15, Part2), "802");
    }
}
