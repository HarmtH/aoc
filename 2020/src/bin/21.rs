#![warn(clippy::all)]

use aoc::*;
use std::collections::HashMap;
use std::collections::HashSet;
use itertools::Itertools;

#[derive(Debug)]
struct Food<'a> { ingredients: HashSet<&'a str>, allergens: HashSet<&'a str> }

fn solve(input: &str, part: Part) -> (usize, String) {
    let foods: Vec<Food> = input
        .lines()
        .map(|line| line
            .strip_suffix(")").unwrap()
            .split(" (contains "))
        .map(|mut parts| Food {
            ingredients: parts.next().unwrap()
                .split(' ')
                .collect(),
            allergens: parts.next().unwrap()
                .split(", ")
                .collect()})
        .collect();

    let mut allergen_to_possible_ingredients: HashMap<&str, HashSet<&str>> = HashMap::new();

    for food in foods.iter() {
        for allergen in food.allergens.iter() {
            allergen_to_possible_ingredients
                .entry(&allergen)
                .and_modify(|e| *e = &*e & &food.ingredients)
                .or_insert_with(|| food.ingredients.clone());
        }
    }

    match part {
        Part1 => {
            let possible_ingredients: HashSet<&str> = allergen_to_possible_ingredients
                .values()
                .fold(HashSet::new(), |acc, x| &acc | x);

            (foods
             .iter()
             .map(|food| food.ingredients.difference(&possible_ingredients).count())
             .sum(), "".into())
        }
        Part2 => {
            let mut matched_ingredients: HashSet<&str> = HashSet::new();

            while allergen_to_possible_ingredients.values().any(|possible_ingredients| possible_ingredients.len() > 1) {
                for possible_ingredients in allergen_to_possible_ingredients.values_mut() {
                    if possible_ingredients.len() == 1 {
                        matched_ingredients.insert(possible_ingredients.iter().next().unwrap());
                    } else {
                        *possible_ingredients = possible_ingredients.difference(&matched_ingredients).copied().collect();
                    }
                }
            }

            (0, allergen_to_possible_ingredients
             .keys()
             .sorted()
             .map(|k| allergen_to_possible_ingredients[k].iter().next().unwrap())
             .join(","))
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/21.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1).0);
    println!("Part 2: {}", solve(&input, Part2).1);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)\n\
                      trh fvjkl sbzzf mxmxvkd (contains dairy)\n\
                      sqjhc fvjkl (contains soy)\n\
                      sqjhc mxmxvkd sbzzf (contains fish)\n";

        assert_eq!(solve(input1, Part1).0, 5);
        assert_eq!(solve(input1, Part2).1, "mxmxvkd,sqjhc,fvjkl");
    }
}
