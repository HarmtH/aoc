#![warn(clippy::all)]

pub use Part::*;

#[derive(PartialEq)]
pub enum Part { Part1, Part2 }
