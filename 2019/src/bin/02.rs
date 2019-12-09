#![warn(clippy::all)]

#[allow(unused_macros)]
#[cfg(debug_assertions)]
macro_rules! log {
    ($( $args:expr ),*) => { println!( $( $args ),* ); }
}
#[allow(unused_macros)]
#[cfg(not(debug_assertions))]
macro_rules! log {
    ($( $args:expr ),*) => {()}
}
#[allow(unused_macros)]
macro_rules! nolog {
    ($( $args:expr ),*) => {()}
}

use std::fs;

type GenResult<T> = Result<T, Box<dyn std::error::Error>>;

fn main() -> GenResult<()> {
    let input = fs::read_to_string("inputs/02.in")?;

    println!("Part 1: {}", solve(&input, 1)?);
    println!("Part 2: {}", solve(&input, 2)?);

    Ok(())
}

fn solve(input: &str, part: u8) -> GenResult<String> {
    match part {
        1 => Ok(run(input, Some(12), Some(2))?.to_string()),
        2 => {
            for noun in 0 .. 100 {
                for verb in 0 .. 100 {
                    log!("Trying noun {} and verb {}", noun, verb);
                    if run(input, Some(noun), Some(verb))? == 1969_0720 {
                        return Ok((100 * noun + verb).to_string())
                    }
                }
            }
            Err("No solution found".into())
        }
        part => Err(format!("Illegal part: {}", part).into()),
    }
}

fn run(input: &str, noun: Option<usize>, verb: Option<usize>) -> GenResult<usize> {
    let mut int_code: Vec<usize> = input
        .trim()
        .split(',')
        .map(|s| s.parse())
        .collect::<Result<Vec<_>, _>>()?;

    if let Some(noun) = noun {
        int_code[1] = noun;
    }

    if let Some(verb) = verb {
        int_code[2] = verb;
    }

    let mut ip = 0;

    loop {
        match int_code[ip] {
            1 => {
                let store_loc = int_code[ip+3];
                int_code[store_loc] = int_code[int_code[ip+1]] + int_code[int_code[ip+2]];
                log!("{:?}", &int_code)
            },
            2 => {
                let store_loc = int_code[ip+3];
                int_code[store_loc] = int_code[int_code[ip+1]] * int_code[int_code[ip+2]];
                log!("{:?}", &int_code)
            },
            99 => return Ok(int_code[0]),
            op => return Err(format!("Unknown opcode found: {}", op).into()),
        }

        ip += 4;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_run() -> GenResult<()> {
        let input1 = "1,9,10,3,2,3,11,0,99,30,40,50";
        let input2 = "1,1,1,4,99,5,6,0,99";

        assert_eq!(run(input1, None, None)?, 3500);
        assert_eq!(run(input2, None, None)?, 30);
        Ok(())
    }
}
