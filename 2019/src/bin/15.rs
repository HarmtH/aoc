#![warn(clippy::all)]

use aoc::*;
use Direction::*;

enum Outcome { HitWall, Moved, Found }
use Outcome::*;

impl From<i64> for Outcome {
    fn from(v: i64) -> Self {
        match v {
            0 => Outcome::HitWall,
            1 => Outcome::Moved,
            2 => Outcome::Found,
            _ => panic!(),
        }
    }
}

fn solve(input: &str, part: Part) -> String {
    let machine: IntCodeEmulator = input.into();
    let mut pq = priority_queue::PriorityQueue::new();
    let mut seen = std::collections::HashSet::new();

    pq.push((Point{x:0, y:0}, machine.program.clone()), -1);

    let mut last_prio = None;
    'outer: while !pq.is_empty() {
        let ((cur_point, cur_program), cur_prio) = pq.pop().unwrap();
        last_prio = Some(cur_prio);
        for next_dir in [UP, DOWN, LEFT, RIGHT].iter() {
            let next_point = cur_point.stepped(*next_dir, 1);
            if seen.contains(&next_point) { continue }
            let mut machine: IntCodeEmulator = cur_program.clone().into();
            machine.input.push_back(match next_dir { UP => 1, DOWN => 2, LEFT => 3, RIGHT => 4 });
            machine.run_to_interrupt_list(&[Interrupt::InputRequested]);
            match machine.output.pop_back().unwrap().into() {
                HitWall => (),
                Moved => {
                    seen.insert(next_point);
                    pq.push((next_point, machine.program.clone()), cur_prio - 1);
                }
                Found => match part {
                    Part1 => break 'outer,
                    Part2 => {
                        seen.clear();
                        pq.clear();
                        seen.insert(next_point);
                        pq.push((next_point, machine.program.clone()), 0);
                    }
                }
            }
        }
    }
    (-last_prio.unwrap()).to_string()
}

fn main() {
    let input = std::fs::read_to_string("inputs/15.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}
