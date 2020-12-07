#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;
use std::collections::HashMap;
use std::collections::HashSet;

fn solve(input: &str, part: Part) -> usize {
    let order: HashMap<&str, Vec<(u8, &str)>> = input
        .lines()
        .map(|l| l
            .split("contain")
            .collect_tuple::<(&str, &str)>()
            .unwrap())
        .map(|(outer, inners)| -> (&str, Vec<(u8, &str)>) {
            (&outer[0..(outer.len() - 6)], inners
             .split(",")
             .filter(|bag| !bag.contains("no other bags"))
             .map(|bag| (bag[1..2].parse::<u8>().unwrap(), &bag[3..bag.find(" bag").unwrap()]))
             .collect())})
        .collect();

    match part {
        Part1 => {
            let mut results = HashSet::new();
            let mut searches = vec!("shiny gold");
            while let Some(search) = searches.pop() {
                for (outer, inners) in order.iter() {
                    if inners.iter().any(|e| e.1 == search) && results.insert(outer) {
                        searches.push(outer)
                    }
                }
            }
            results.len()

        }
        Part2 => {
            fn get_bag(bag: &str, order: &HashMap<&str, Vec<(u8, &str)>>) -> usize {
                order.get(bag).unwrap().iter().map(|(amount, name)| (*amount as usize) * (1 + get_bag(name, order))).sum::<usize>()
            }
            get_bag("shiny gold", &order)
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/07.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "light red bags contain 1 bright white bag, 2 muted yellow bags.\n\
                      dark orange bags contain 3 bright white bags, 4 muted yellow bags.\n\
                      bright white bags contain 1 shiny gold bag.\n\
                      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.\n\
                      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.\n\
                      dark olive bags contain 3 faded blue bags, 4 dotted black bags.\n\
                      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.\n\
                      faded blue bags contain no other bags.\n\
                      dotted black bags contain no other bags.\n";

        assert_eq!(solve(input1, Part1), 4);
        assert_eq!(solve(input1, Part2), 32);

        let input2 = "shiny gold bags contain 2 dark red bags.\n\
                      dark red bags contain 2 dark orange bags.\n\
                      dark orange bags contain 2 dark yellow bags.\n\
                      dark yellow bags contain 2 dark green bags.\n\
                      dark green bags contain 2 dark blue bags.\n\
                      dark blue bags contain 2 dark violet bags.\n\
                      dark violet bags contain no other bags.\n";

        assert_eq!(solve(input2, Part2), 126);
    }
}
