#![warn(clippy::all)]
#![feature(destructuring_assignment)]

use aoc::*;
use std::convert::TryFrom;
use std::convert::TryInto;
use num_enum::IntoPrimitive;
use num_enum::TryFromPrimitive;

#[derive(Debug, Copy, Clone, PartialEq, IntoPrimitive, TryFromPrimitive)]
#[repr(i32)]
enum Direction { East = 0, West = 180, North = 90, South = 270 }

#[derive(Debug, PartialEq)]
enum Action { MoveNorth, MoveSouth, MoveEast, MoveWest, TurnLeft, TurnRight, MoveForward }

#[derive(Debug)]
struct Position {x: i32, y: i32}

type Instruction = (Action, i32);
type InstructionList = Vec<Instruction>;

impl TryFrom<u8> for Action {
    type Error = ();
    fn try_from(input: u8) -> Result<Action, Self::Error> {
        match input {
            b'N'  => Ok(Action::MoveNorth),
            b'S'  => Ok(Action::MoveSouth),
            b'E'  => Ok(Action::MoveEast),
            b'W'  => Ok(Action::MoveWest),
            b'L'  => Ok(Action::TurnLeft),
            b'R'  => Ok(Action::TurnRight),
            b'F'  => Ok(Action::MoveForward),
            _     => Err(()),
        }
    }
}

impl Direction {
    fn turn_degrees(&mut self, value: i32) {
        assert!(value % 90 == 0);
        let current_degrees: i32 = (*self).into();
        let new_degrees = (current_degrees + value + 360) % 360;
        *self = new_degrees.try_into().unwrap();
    }
}

impl Position {
    fn rotate_degrees(&mut self, value: i32) {
        fn sin(degrees: i32) -> i32 {
            match degrees { 0 => 0, 90 => 1, 180 => 0, 270 => -1, _ => unreachable!() }
        }
        fn cos(degrees: i32) -> i32 {
            sin((degrees + 90) % 360)
        }
        let degrees = (value + 360) % 360;
        (self.x, self.y) = (cos(degrees) * self.x - sin(degrees) * self.y,
                            sin(degrees) * self.x + cos(degrees) * self.y);
    }

    fn get_manhattan(&self) -> i32 {
        return self.x.abs() + self.y.abs()
    }
}

fn solve(input: &str, part: Part) -> i32 {
    let instructions: InstructionList = input
        .lines()
        .map(|line| (line.as_bytes()[0].try_into().unwrap(),
            line[1..line.len()].parse().unwrap()))
        .collect();

    match part {
        Part1 => {
            let mut direction: Direction = Direction::East;
            let mut position: Position = Position{x: 0, y: 0};
            for (action, value) in instructions {
                match action {
                    Action::MoveNorth => position.y += value,
                    Action::MoveSouth => position.y -= value,
                    Action::MoveEast => position.x += value,
                    Action::MoveWest => position.x -= value,
                    Action::TurnLeft => direction.turn_degrees(value),
                    Action::TurnRight => direction.turn_degrees(-value),
                    Action::MoveForward => match direction {
                        Direction::North => position.y += value,
                        Direction::South => position.y -= value,
                        Direction::East => position.x += value,
                        Direction::West => position.x -= value,
                    }
                }
            }
            position.get_manhattan()
        }
        Part2 => {
            let mut ship_position: Position = Position{x: 0, y: 0};
            let mut waypoint_relative_position: Position = Position{x: 10, y: 1};
            for (action, value) in instructions {
                match action {
                    Action::MoveNorth => waypoint_relative_position.y += value,
                    Action::MoveSouth => waypoint_relative_position.y -= value,
                    Action::MoveEast => waypoint_relative_position.x += value,
                    Action::MoveWest => waypoint_relative_position.x -= value,
                    Action::TurnLeft => waypoint_relative_position.rotate_degrees(value),
                    Action::TurnRight => waypoint_relative_position.rotate_degrees(-value),
                    Action::MoveForward => {
                        ship_position.x += value * waypoint_relative_position.x;
                        ship_position.y += value * waypoint_relative_position.y;
                    }
                }
            }
            ship_position.get_manhattan()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/12.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "F10\n\
                      N3\n\
                      F7\n\
                      R90\n\
                      F11\n";

        assert_eq!(solve(input1, Part1), 25);
        assert_eq!(solve(input1, Part2), 286);
    }
}
