#![warn(clippy::all)]

use aoc::*;

fn get_layers(input: &str, width: usize, height: usize) -> Vec<&[u8]> {
    input
        .trim()
        .as_bytes()
        .chunks(width*height)
        .collect()
}

fn solve(input: &str, part: Part) -> String {
    const ROWS: usize = 6;
    const COLS: usize = 25;

    let layers = get_layers(input, COLS, ROWS);

    match part {
        Part1 => {
            let min0layer = layers
                .iter()
                .min_by_key(|img| bytecount::count(img, b'0'))
                .unwrap();

            (bytecount::count(min0layer, b'1') * bytecount::count(min0layer, b'2')).to_string()
        }
        Part2 => {
            (0..ROWS)
                .map(|_| 0..COLS)
                .enumerate()
                .map(|(row, colrange)| colrange
                     .map(|col| layers
                          .iter()
                          .map(|layer| layer[row*COLS+col])
                          .find(|&u8chr| u8chr != b'2')
                          .unwrap())
                     .map(|u8chr| if u8chr == b'0' {' '} else {'\u{2588}'})
                     .collect::<String>())
                .collect::<Vec<String>>()
                .join("\n")
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/08.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2:\n{}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_layers() {
        let input1 = "123456789012";

        assert_eq!(get_layers(input1, 3, 2), &[&[1,2,3,4,5,6],&[7,8,9,0,1,2]])
    }
}
