#![warn(clippy::all)]

use aoc::*;
use std::collections::HashSet;
use itertools::iproduct;

type CubeMap3d = HashSet<Point3d>;

type CubeMap4d = HashSet<Point4d>;

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
struct Point3d { x: i32, y: i32, z: i32 }
impl Point3d {
    fn add(self, dx: i32, dy: i32, dz: i32) -> Self {
        Point3d{ x: self.x + dx, y: self.y + dy, z: self.z + dz }
    }
    fn get_neighbours(self) -> impl std::iter::Iterator<Item = Self> {
        iproduct!(-1..=1, -1..=1, -1..=1)
            .filter(|&(dx, dy, dz)| !(dx==0 && dy==0 && dz==0))
            .map(move |(dx, dy, dz)| self.add(dx, dy, dz))
    }
    fn check_active_neighbours(self, cubemap: &CubeMap3d) -> usize {
        self
            .get_neighbours()
            .filter(|x| cubemap.contains(x))
            .count()
    }
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
struct Point4d { w: i32, x: i32, y: i32, z: i32 }
impl Point4d {
    fn add(self, dw: i32, dx: i32, dy: i32, dz: i32) -> Self {
        Point4d{ w: self.w + dw, x: self.x + dx, y: self.y + dy, z: self.z + dz }
    }
    fn get_neighbours(self) -> impl std::iter::Iterator<Item = Self> {
        iproduct!(-1..=1, -1..=1, -1..=1, -1..=1)
            .filter(|&(dw, dx, dy, dz)| !(dw==0 && dx==0 && dy==0 && dz==0))
            .map(move |(dw, dx, dy, dz)| self.add(dw, dx, dy, dz))
    }
    fn check_active_neighbours(self, cubemap: &CubeMap4d) -> usize {
        self
            .get_neighbours()
            .filter(|x| cubemap.contains(x))
            .count()
    }
}

fn solve(input: &str, part: Part) -> usize {
    match part {
        Part1 => {
            let mut cubemap: CubeMap3d = input
                .lines()
                .enumerate()
                .flat_map(|(y, line)| line
                    .chars()
                    .enumerate()
                    .filter(|(_, chr)| *chr == '#')
                    .map(move |(x, _chr)| Point3d{x: x as i32, y: y as i32, z: 0}))
                .collect();

            for _round in 0..6 {
                let mut _cubemap: CubeMap3d = HashSet::new();
                for point in cubemap.iter().flat_map(|active_point| active_point.get_neighbours()).collect::<CubeMap3d>() {
                    let active_neighbours = point.check_active_neighbours(&cubemap);
                    if cubemap.contains(&point) {
                        if active_neighbours == 2 || active_neighbours == 3 {
                            _cubemap.insert(point);
                        }
                    } else if active_neighbours == 3 {
                        _cubemap.insert(point);
                    }
                }
                cubemap = _cubemap;
            }

            cubemap.len()
        }
        Part2 => {
            let mut cubemap: CubeMap4d = input
                .lines()
                .enumerate()
                .flat_map(|(y, line)| line
                    .chars()
                    .enumerate()
                    .filter(|(_, chr)| *chr == '#')
                    .map(move |(x, _chr)| Point4d{w: 0, x: x as i32, y: y as i32, z: 0}))
                .collect();

            for _round in 0..6 {
                let mut _cubemap: CubeMap4d = HashSet::new();
                for point in cubemap.iter().flat_map(|active_point| active_point.get_neighbours()).collect::<CubeMap4d>() {
                    let active_neighbours = point.check_active_neighbours(&cubemap);
                    if cubemap.contains(&point) {
                        if active_neighbours == 2 || active_neighbours == 3 {
                            _cubemap.insert(point);
                        }
                    } else if active_neighbours == 3 {
                        _cubemap.insert(point);
                    }
                }
                cubemap = _cubemap;
            }

            cubemap.len()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/17.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = ".#.\n\
                      ..#\n\
                      ###\n";

        assert_eq!(solve(input1, Part1), 112);
        assert_eq!(solve(input1, Part2), 848);
    }
}
