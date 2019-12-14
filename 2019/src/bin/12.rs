#![warn(clippy::all)]

use aoc::*;
use itertools::Itertools;

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
struct Moon {
    p: [i16; 3], // position
    v: [i16; 3], // velocity
}

fn solve(input: &str, part: Part, cycles: usize) -> String {
    let re_string = r"<x=(?P<x>-?\d+), y=(?P<y>-?\d+), z=(?P<z>-?\d+)>";
    let re = regex::Regex::new(re_string).unwrap();

    let mut moons = input
        .lines()
        .map(|l| re.captures(l).unwrap())
        .map(|caps| Moon {p: [caps["x"].parse().unwrap(),
                              caps["y"].parse().unwrap(),
                              caps["z"].parse().unwrap()],
                          v: [0,0,0]})
        .collect::<Vec<Moon>>();

    let start = moons.clone();
    let mut repeats = [None; 3];

    let combs: Vec<(usize, usize)> = (0..moons.len()).combinations(2).flat_map(|moons| moons.into_iter().tuples()).collect();

    for cycle in 1 .. {
        for &(m0, m1) in combs.iter() {
            for (i, rpt) in repeats.iter().enumerate() {
                if rpt.is_some() { continue }
                moons[m0].v[i] += (moons[m1].p[i] - moons[m0].p[i]).signum();
                moons[m1].v[i] += (moons[m0].p[i] - moons[m1].p[i]).signum();
            }
        }

        for (p, i) in moons.iter_mut()
            .flat_map(|m| m.p.iter_mut().zip(m.v.iter())) {
            *p += i;
        }

        match part {
            Part1 => {
                if cycle == cycles {
                    return moons
                        .iter()
                        .map(|m| m.p.iter().map(|x| x.abs()).sum::<i16>() *
                             m.v.iter().map(|x| x.abs()).sum::<i16>())
                        .sum::<i16>()
                        .to_string()
                }
            }
            Part2 => {
                for (i, rpt) in repeats.iter_mut().enumerate() {
                    if rpt.is_none() && moons
                            .iter()
                            .zip(start.iter())
                            .all(|(cur,start)| cur.p[i] == start.p[i]
                                 && cur.v[i] == start.v[i])
                    {
                        *rpt = Some(cycle)
                    }
                }
                if repeats.iter().all(|rpt| rpt.is_some()) {
                    return repeats.iter()
                        .fold(1, |f, c| num::integer::lcm(f, c.unwrap()))
                        .to_string()
                }
            }
        }
    }
    unreachable!()
}

fn main() {
    let input = std::fs::read_to_string("inputs/12.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1, 1000));
    println!("Part 2: {}", solve(&input, Part2, 0));
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT1: &str = "<x=-1, y=0, z=2>\n\
                           <x=2, y=-10, z=-7>\n\
                           <x=4, y=-8, z=8>\n\
                           <x=3, y=5, z=-1>";

    const INPUT2: &str = "<x=-8, y=-10, z=0>\n\
                           <x=5, y=5, z=10>\n\
                           <x=2, y=-7, z=3>\n\
                           <x=9, y=-8, z=-3>";

    #[test]
    fn test_1() {
        assert_eq!(solve(INPUT1, Part1, 10), "179");
    }

    #[test]
    fn test_2() {
        assert_eq!(solve(INPUT1, Part2, 0), "2772");
    }

    #[test]
    fn test_3() {
        assert_eq!(solve(INPUT2, Part2, 0), "4686774924");
    }
}
