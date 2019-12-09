#![warn(clippy::all)]

use aoc::*;
use petgraph::*;
use petgraph::graphmap::UnGraphMap;

fn solve(input: &str, part: Part) -> String {
    let mut graph = UnGraphMap::new();
    for line in input.trim().split('\n') {
        let mut planets = line.split(')');
        let (left, right) = (planets.next().unwrap(), planets.next().unwrap());
        graph.add_edge(left, right, ());
    }

    match part {
        Part1 => {
            let distances = algo::dijkstra(&graph, "COM", None, |_| 1);
            distances.values().sum::<u32>().to_string()
        }
        Part2 => {
            let distances = algo::dijkstra(&graph, "YOU", Some("SAN"), |_| 1);
            (*distances.get("SAN").unwrap() - 2).to_string()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/06.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1));
    println!("Part 2: {}", solve(&input, Part2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input11 = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L";
        let input21 = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN";

        assert_eq!(solve(input11, Part1), "42");
        assert_eq!(solve(input21, Part2), "4");
    }
}
