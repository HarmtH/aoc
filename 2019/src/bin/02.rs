#![warn(clippy::all)]

type GenResult<T> = Result<T, Box<dyn std::error::Error>>;

fn main() -> GenResult<()> {
    let input = std::fs::read_to_string("inputs/02.in")?;

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
                    //println!("Trying noun {} and verb {}", noun, verb);
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

fn run(input: &str, noun: Option<i32>, verb: Option<i32>) -> GenResult<i32> {
    let mut machine = aoc::IntCodeEmulator::from(input);

    if let Some(noun) = noun {
        machine.program[1] = noun;
    }

    if let Some(verb) = verb {
        machine.program[2] = verb;
    }

    machine.run_to_halt();

    Ok(machine.program[0])
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
