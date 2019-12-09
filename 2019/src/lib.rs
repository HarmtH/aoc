#![warn(clippy::all)]

pub enum Part {
    Part1,
    Part2,
}
pub use Part::*;

mod int_code_emulator;
pub use int_code_emulator::*;
