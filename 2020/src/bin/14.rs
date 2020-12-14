#![warn(clippy::all)]

use aoc::*;
use std::collections::HashMap;

#[derive(Debug)]
enum Kind<'a> { Mask(&'a str), Mem(usize,usize) }

fn solve(input: &str, part: Part) -> usize {
    let instructions: Vec<Kind> = input
        .lines()
        .map(|line| -> Kind {
            match &line[0..3] {
                "mas" => Kind::Mask(&line[7..line.len()]),
                "mem" => Kind::Mem(
                    line[4..line.find("]").unwrap()].parse().unwrap(),
                    line[line.find("=").unwrap()+2..line.len()].parse().unwrap()),
                _ => panic!("illegal sequence"),
            }})
        .collect();

    let mut memory: HashMap<usize, usize> = HashMap::new();

    match part {
        Part1 => {
            let mut andmask: usize = 0xDEADBEEF;
            let mut ormask: usize = 0xCAFEBABE;

            for instruction in instructions {
                match instruction {
                    Kind::Mask(mask) => {
                        ormask = usize::from_str_radix(&mask.replace("X", "0"), 2).unwrap();
                        andmask = usize::from_str_radix(&mask.replace("X", "1"), 2).unwrap();
                    },
                    Kind::Mem(address, value) => {
                        *memory.entry(address).or_default() = value & andmask | ormask;
                    }
                }
            }

            memory.values().sum()
        }
        Part2 => {
            let mut mask: &str = "";

            for instruction in instructions {
                match instruction {
                    Kind::Mask(_mask) => mask = _mask,
                    Kind::Mem(address, value) => {
                        let mut addresses: Vec<usize> = vec!(address);
                        for (idx, c) in mask.chars().rev().enumerate() {
                            if c == '1' { addresses = addresses.iter().map(|&value| value | (1 << idx)).collect() }
                            if c == 'X' { addresses = addresses.iter().flat_map(|&value| vec!(value, value ^ (1 << idx))).collect() }
                        }
                        for address in addresses {
                            *memory.entry(address).or_default() = value;
                        }
                    }
                }
            }

            memory.values().sum()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/14.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X\n\
                      mem[8] = 11\n\
                      mem[7] = 101\n\
                      mem[8] = 0\n";

        assert_eq!(solve(input1, Part1), 165);

        let input2 = "mask = 000000000000000000000000000000X1001X\n\
                      mem[42] = 100\n\
                      mask = 00000000000000000000000000000000X0XX\n\
                      mem[26] = 1\n";

        assert_eq!(solve(input2, Part2), 208);
    }
}
