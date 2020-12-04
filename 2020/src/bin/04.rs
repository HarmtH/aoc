#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;
use regex::Regex;
use std::collections::HashMap;

fn solve(input: &str, part: Part) -> usize {

    let passports: Vec<HashMap<&str, &str>> = input
        .trim()
        .split("\n\n")
        .map(|passport: &str| passport
            .split(|c| c == ' ' || c == '\n')
            .flat_map(|entry: &str| entry
                .split(':').tuples())
            .collect())
        .collect();

    fn contains_all_keys(passport: &&HashMap<&str, &str>) -> bool {
        ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
            .iter()
            .all(|field| passport.contains_key(field))
    }

    match part {
        Part1 => {
            passports
                .iter()
                .filter(contains_all_keys)
                .count()
        }
        Part2 => {
            let hcl_re = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
            let pid_re = Regex::new(r"^[0-9]{9}$").unwrap();
            passports
                .iter()
                .filter(contains_all_keys)
                .filter(|passport|
                    (1920..=2002).contains(&passport["byr"].parse().unwrap()) &&
                    (2010..=2020).contains(&passport["iyr"].parse().unwrap()) &&
                    (2020..=2030).contains(&passport["eyr"].parse().unwrap()) &&
                    (passport["hgt"].strip_suffix("cm").map_or(false, |hgt| (150..=193).contains(&hgt.parse().unwrap())) ||
                     (passport["hgt"].strip_suffix("in").map_or(false, |hgt| (59..=76).contains(&hgt.parse().unwrap())))) &&
                    hcl_re.is_match(passport["hcl"]) &&
                    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(&passport["ecl"]) &&
                    pid_re.is_match(passport["pid"]))
                .count()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/04.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input1 = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\n\
                      byr:1937 iyr:2017 cid:147 hgt:183cm\n\
                      \n\
                      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\n\
                      hcl:#cfa07d byr:1929\n\
                      \n\
                      hcl:#ae17e1 iyr:2013\n\
                      eyr:2024\n\
                      ecl:brn pid:760753108 byr:1931\n\
                      hgt:179cm\n\
                      \n\
                      hcl:#cfa07d eyr:2025 pid:166559648\n\
                      iyr:2011 ecl:brn hgt:59in\n";

        assert_eq!(solve(input1, Part1), 2);

        let input2 = "eyr:1972 cid:100\n\
                      hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926\n\
                      \n\
                      iyr:2019\n\
                      hcl:#602927 eyr:1967 hgt:170cm\n\
                      ecl:grn pid:012533040 byr:1946\n\
                      \n\
                      hcl:dab227 iyr:2012\n\
                      ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277\n\
                      \n\
                      hgt:59cm ecl:zzz\n\
                      eyr:2038 hcl:74454a iyr:2023\n\
                      pid:3556412378 byr:2007\n";

        let input3 = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980\n\
                      hcl:#623a2f\n\
                      \n\
                      eyr:2029 ecl:blu cid:129 byr:1989\n\
                      iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm\n\
                      \n\
                      hcl:#888785\n\
                      hgt:164cm byr:2001 iyr:2015 cid:88\n\
                      pid:545766238 ecl:hzl\n\
                      eyr:2022\n\
                      \n\
                      iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719\n";

        assert_eq!(solve(input2, Part2), 0);
        assert_eq!(solve(input3, Part2), 4);
    }
}
