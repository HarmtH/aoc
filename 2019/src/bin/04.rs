#![warn(clippy::all)]

enum Part {
    Part1,
    Part2,
}

fn solve(input: &str, part: Part) -> String {
    let numbers: Vec<u32> = input
        .trim()
        .split('-')
        .map(|num| num
             .parse()
             .unwrap())
        .collect();

    let mut cnt1 = 0;
    let mut cnt2 = 0;
    for dig1 in numbers[0]/100_000 ..= 9 {
        for dig2 in dig1 ..= 9 {
            for dig3 in dig2 ..= 9 {
                for dig4 in dig3 ..= 9 {
                    for dig5 in dig4 ..= 9 {
                        for dig6 in dig5 ..= 9 {
                            let sum = dig1 * 100_000 + dig2 * 10_000 + dig3 * 1_000 +
                                dig4 * 100 + dig5 * 10 + dig6;
                            if sum > numbers[0] && sum < numbers[1] {
                                cnt1 += if dig1 == dig2 || dig2 == dig3 || dig3 == dig4 ||
                                    dig4 == dig5 || dig5 == dig6 { 1 } else { 0 };
                                cnt2 += if dig1 == dig2 && dig2 != dig3 ||
                                    dig1 != dig2 && dig2 == dig3 && dig3 != dig4 ||
                                    dig2 != dig3 && dig3 == dig4 && dig4 != dig5 ||
                                    dig3 != dig4 && dig4 == dig5 && dig5 != dig6 ||
                                    dig4 != dig5 && dig5 == dig6 { 1 } else { 0 }
                            }
                        }
                    }
                }
            }
        }
    }
    match part {
        Part::Part1 => cnt1.to_string(),
        Part::Part2 => cnt2.to_string(),
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/04.in").unwrap();

    println!("Part 1: {}", solve(&input, Part::Part1));
    println!("Part 2: {}", solve(&input, Part::Part2));
}
