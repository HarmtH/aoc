#![warn(clippy::all)]

use aoc::*;

#[derive(Debug, PartialEq, Clone)]
#[allow(dead_code)]
enum Tile {
    Empty = 0,
    Wall,
    Block,
    Paddle,
    Ball,
}

impl std::convert::From<i64> for Tile {
    fn from(v: i64) -> Self {
        unsafe { std::mem::transmute(v as u8) }
    }
}

struct ScreenBuf {
    tiles: Vec<Vec<Tile>>,
    score: Option<i64>
}

fn out_to_screenbuf(screen: &mut ScreenBuf, out: &mut std::collections::VecDeque<i64>) {
    while !out.is_empty() {
        let mut get = || out.pop_front().unwrap();
        let (x, y, z) = (get(), get(), get());
        if x == -1 && y == 0 {
            screen.score = Some(z)
        } else {
            let y = y as usize; let x = x as usize;
            if y >= screen.tiles.len() { screen.tiles.resize_with(y+1, Default::default) }
            if x >= screen.tiles[y].len() { screen.tiles[y].resize(x+1, Tile::Empty) };
            screen.tiles[y][x] = z.into();
        }
    }
}

fn display(screen: &ScreenBuf) {
    use Tile::*;
    println!("\x1b[H\x1b[J\x1b[3JScore: {}\n{}",
         screen.score.unwrap(),
         screen.tiles
             .iter()
             .map(|y| y
                  .iter()
                  .map(|x| match x {
                      Empty => " ",
                      Wall => "#",
                      Block => "x",
                      Paddle => "^",
                      Ball => "*"})
                  .collect::<String>())
             .collect::<Vec<String>>()
             .join("\n"))
}

fn solve(input: &str, part: Part, auto_play: bool) -> String {
    let mut machine: IntCodeEmulator = input.into();
    let mut screenbuf = ScreenBuf{tiles: Vec::new(), score: None};

    match part {
        Part1 => {
            machine.run_to_halt();
            out_to_screenbuf(&mut screenbuf, &mut machine.output);
            screenbuf.tiles.iter().flat_map(|x| x.iter()).filter(|&v| v == &Tile::Block).count().to_string()
        }
        Part2 => {
            machine.program[0] = 2;
            loop {
                let int = machine.run_to_interrupt_list(&[Interrupt::InputRequested, Interrupt::Halted]);
                if !machine.output.is_empty() {
                    out_to_screenbuf(&mut screenbuf, &mut machine.output);
                    if !auto_play {
                        display(&screenbuf);
                    }
                }
                match int {
                    Interrupt::Halted => break,
                    Interrupt::InputRequested => {
                        if auto_play {
                            let mut xpaddle = None;
                            let mut xball = None;
                            for yvec in screenbuf.tiles.iter() {
                                for (x, tile) in yvec.iter().enumerate() {
                                    if tile == &Tile::Paddle { xpaddle = Some(x as i64) }
                                    if tile == &Tile::Ball { xball = Some(x as i64) }
                                }
                            }
                            machine.input.push_back((xball.unwrap() - xpaddle.unwrap()).signum());
                        } else {
                            use std::io::Read;
                            for chr in std::io::stdin().lock().bytes() {
                                match chr {
                                    Ok(b'a') => machine.input.push_back(-1),
                                    Ok(b'd') => machine.input.push_back(1),
                                    Ok(b's') => machine.input.push_back(0),
                                    Ok(b'\n') => { if machine.input.is_empty() { machine.input.push_back(0) } break },
                                    _ => (),
                                }
                            }
                        }
                    }
                    _ => ()
                }
            }
            screenbuf.score.unwrap().to_string()
        }
    }
}

fn main() {
    let input = std::fs::read_to_string("inputs/13.in").unwrap();

    println!("Part 1: {}", solve(&input, Part1, true));
    println!("Part 2: {}", solve(&input, Part2, true));
}
