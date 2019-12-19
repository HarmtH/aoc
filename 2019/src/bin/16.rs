#![warn(clippy::all)]

use aoc::*;

fn fft_cache(input: Vec<i16>, zips: &[Vec<i16>]) -> Vec<i16> {
    input
        .iter()
        .enumerate()
        .map(|(idx, _)| input
             .iter()
             .zip(&zips[idx])
             .map(|(i,j)|i * j)
             .sum::<i16>().abs() % 10)
        .collect()
}

fn solve(input: &str, part: Part) -> String {
    let list = input
        .trim()
        .chars()
        .map(|c| c.to_digit(10).unwrap() as i16)
        .collect::<Vec<i16>>();

    match part {
        Part1 => {
            let zips: Vec<Vec<i16>> = (0..list.len())
                .map(|idx| [0, 1, 0, -1]
                     .iter()
                     .flat_map(|i| std::iter::repeat(*i).take(idx+1))
                     .cycle()
                     .skip(1)
                     .take(list.len())
                     .collect::<Vec<i16>>())
                .collect();

            std::iter::repeat(&fft_cache)
                .take(100)
                .fold(list, |list, fft| fft(list, &zips))
                .iter()
                .map(|i| std::char::from_digit(*i as u32, 10).unwrap())
                .take(8)
                .collect()
        }
        Part2 => {
            let offset: usize = list
                .iter()
                .take(7)
                .fold(0, |acc, val| *val as usize + acc * 10);

            let num_to_calc = 10_000 * list.len() - offset;

            let mut hugelist = list
                .iter()
                .cycle()
                .skip(offset)
                .take(num_to_calc)
                .copied()
                .map(|x| x as u32)
                .collect::<Vec<u32>>();

            for _ in 0..100 {
                let mut cumsum = 0;
                for num in hugelist.iter_mut().rev() {
                    cumsum += *num;
                    *num = cumsum;
                }
                for num in hugelist.iter_mut().rev() {
                    *num %= 10
                }
            }

            hugelist
                .into_iter()
                .map(|i| std::char::from_digit(i, 10).unwrap())
                .take(8)
                .collect::<String>()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/16.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part1() {
        let input11 = "80871224585914546619083218645595";
        let input12 = "19617804207202209144916044189917";
        let input13 = "69317163492948606335995924319873";

        assert_eq!(solve(input11, Part1), "24176176");
        assert_eq!(solve(input12, Part1), "73745418");
        assert_eq!(solve(input13, Part1), "52432133");
    }

    #[test]
    fn test_part2() {
        let input21 = "03036732577212944063491565474664";
        let input22 = "02935109699940807407585447034323";
        let input23 = "03081770884921959731165446850517";
        
        assert_eq!(solve(input21, Part2), "84462026");
        assert_eq!(solve(input22, Part2), "78725270");
        assert_eq!(solve(input23, Part2), "53553731");
    }
}
