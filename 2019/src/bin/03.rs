#![warn(clippy::all)]

use std::collections::HashSet;
use std::collections::HashMap;

enum Part {
    Part1,
    Part2,
}

#[derive(Debug)]
struct Step {
    dir: Point,
    dist: u16,
}

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
struct Point {
    x: i16,
    y: i16,
}

impl Point {
    fn dist(self) -> u16 {
        (self.x.abs() + self.y.abs()) as u16
    }
}

impl std::ops::AddAssign for Point {
    fn add_assign(&mut self, other: Self) {
        *self = Self {
            x: self.x + other.x,
            y: self.y + other.y,
        };
    }
}

impl From<&str> for Step {
    fn from(s: &str) -> Step {
        let bytes = s.as_bytes();
        Step {
            dir: match bytes[0] as char {
                'R' => Point{x: 1, y: 0},
                'U' => Point{x: 0, y: 1},
                'L' => Point{x:-1, y: 0},
                'D' => Point{x: 0, y:-1},
                _  => unreachable!(),
            },
            dist: std::str::from_utf8(&bytes[1..]).unwrap().parse().unwrap(),
        }
    }
}

fn solve(input: &str, part: Part) -> String {
    let wires: Vec<Vec<Step>> = input
        .trim()
        .split('\n')
        .map(|wire| wire
             .split(',')
             .map(|s| s.into())
             .collect())
        .collect();

    let mut wire_points: Vec<HashSet::<Point>> = Vec::new();
    let mut wire_point_score: Vec<HashMap::<Point, u32>> = Vec::new();

    for wire in wires {
        let mut curset = HashSet::<Point>::new();
        let mut curmap = HashMap::<Point, u32>::new();
        let mut curpoint = Point{x: 0, y: 0};
        let mut curscore = 0;
        for step in wire {
            for _ in 0 .. step.dist {
                curpoint += step.dir;
                curscore += 1;
                curset.insert(curpoint);
                curmap.entry(curpoint).or_insert(curscore);
            }
        }
        wire_points.push(curset);
        wire_point_score.push(curmap);
    }

    let intersections = wire_points[0].intersection(&wire_points[1]);

    match part {
        Part::Part1 => intersections.map(|p| p.dist()).min().unwrap().to_string(),
        Part::Part2 => intersections.map(|p| wire_point_score[0].get(p).unwrap() + wire_point_score[1].get(p).unwrap()).min().unwrap().to_string(),
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/03.in").unwrap();

    println!("Part 1: {}", solve(&input, Part::Part1));
    println!("Part 2: {}", solve(&input, Part::Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "R8,U5,L5,D3\nU7,R6,D4,L4";
        let input2 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83";
        let input3 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7";

        assert_eq!(solve(input1, Part::Part1), "6");
        assert_eq!(solve(input2, Part::Part1), "159");
        assert_eq!(solve(input3, Part::Part1), "135");

        assert_eq!(solve(input1, Part::Part2), "30");
        assert_eq!(solve(input2, Part::Part2), "610");
        assert_eq!(solve(input3, Part::Part2), "410");
    }
}
