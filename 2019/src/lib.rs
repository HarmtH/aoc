#![warn(clippy::all)]

#[derive(PartialEq)]
pub enum Part {
    Part1,
    Part2,
}
pub use Part::*;

mod int_code_emulator;
pub use int_code_emulator::*;
