#![warn(clippy::all)]

use aoc::*;
use std::collections::HashMap;

mod robot { 
    use aoc::*;

    pub struct Robot {
        pub dir: Direction,
        pub pos: Point,
    }

    impl Robot {
        pub fn new() -> Robot {
            Robot{ dir: Direction::UP, pos: Point{ x:0, y:0 } }
        }

        pub fn turn_left(&mut self) {
            use aoc::Direction::*;
            self.dir = match self.dir {
                UP => LEFT,
                LEFT => DOWN,
                DOWN => RIGHT,
                RIGHT => UP,
            }
        }

        pub fn turn_right(&mut self) {
            use aoc::Direction::*;
            self.dir = match self.dir {
                UP => RIGHT,
                RIGHT => DOWN,
                DOWN => LEFT,
                LEFT => UP,
            }
        }

        pub fn step(&mut self) {
            self.pos.step(self.dir, 1);
        }
    }
}

mod colour {
    #[derive(PartialEq, Clone, Copy)]
    pub enum Colour { BLACK, WHITE }
    pub use Colour::*;
    impl From<i64> for Colour {
        fn from(int: i64) -> Self {
            if int == 0 { BLACK } else if int == 1 { WHITE } else { panic!() }
        }
    }
    impl From<Colour> for i64 {
        fn from(col: Colour) -> Self {
            if col == BLACK { 0 } else if col == WHITE { 1 } else { panic!() }
        }
    }
}

use robot::*;
use colour::*;

fn solve(input: &str, part: Part) -> String {

    fn run(mut machine: IntCodeEmulator, start_tile_colour: Colour) -> HashMap<Point, Colour> {
        let mut robot = Robot::new();
        let mut coloured_points: HashMap<Point, Colour> = HashMap::new();

        coloured_points.insert(robot.pos, start_tile_colour);
        while !machine.is_halted() {
            let cur_col = coloured_points.get(&robot.pos).unwrap_or(&BLACK);
            machine.input.push_back((*cur_col).into());
            machine.run_to_interrupt_list(&[Interrupt::InputRequested, Interrupt::Halted]);
            if !machine.output.is_empty() {
                coloured_points.insert(robot.pos, machine.output.pop_front().unwrap().into());
                use Direction::*;
                match machine.output.pop_front().unwrap().into() {
                    LEFT => robot.turn_left(),
                    RIGHT => robot.turn_right(),
                    _ => (),
                }
                robot.step();
            }
        }
        coloured_points
    }

    let machine: IntCodeEmulator = input.into();

    match part {
        Part1 => {
            let coloured_points = run(machine, BLACK);
            coloured_points.len().to_string()
        }
        Part2 => {
            let coloured_points = run(machine, WHITE);

            let (min_x, min_y, max_x, max_y) = coloured_points.keys()
                .map(|p| (p.x, p.y, p.x, p.y))
                .fold({use std::i16::*; (MAX, MAX, MIN, MIN)},
                |t, n| (t.0.min(n.0), t.1.min(n.1), t.2.max(n.2), t.3.max(n.3)));

            (min_y ..= max_y)
                .rev()
                .map(|y| (min_x ..= max_x)
                     .map(|x| coloured_points
                          .get(&Point{x, y})
                          .unwrap_or(&BLACK))
                     .map(|c| if c == &BLACK {' '} else {'\u{2588}'})
                     .collect::<String>())
                .collect::<Vec<String>>()
                .join("\n")
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/11.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2:\n{}", solve(&input, Part2));
}
