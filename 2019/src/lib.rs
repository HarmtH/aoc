#![warn(clippy::all)]

mod int_code_emulator;

pub use Part::*;
pub use int_code_emulator::*;

#[derive(PartialEq)]
pub enum Part {
    Part1,
    Part2,
}

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
pub enum Direction { UP, DOWN, LEFT, RIGHT }
use Direction::*;

impl From<i64> for Direction {
    fn from(int: i64) -> Self {
        if int == 0 { LEFT } else if int == 1 { RIGHT } else { panic!() }
    }
}

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
pub struct Point3d {
    pub x: i16,
    pub y: i16,
    pub z: i16,
}

impl Point3d {
    pub fn dist(self) -> u16 {
        (self.x.abs() + self.y.abs() + self.z.abs()) as u16
    }
}

impl std::ops::AddAssign for Point3d {
    fn add_assign(&mut self, other: Self) {
        *self = Self {
            x: self.x + other.x,
            y: self.y + other.y,
            z: self.z + other.z,
        };
    }
}

impl std::ops::Add for Point3d {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
            z: self.z + other.z,
        }
    }
}

impl std::ops::Sub for Point3d {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
            z: self.z - other.z,
        }
    }
}

impl std::ops::Index<u8> for Point3d {
    type Output = i16;
    fn index(&self, s: u8) -> &i16 {
        match s {
            0 => &self.x,
            1 => &self.y,
            2 => &self.z,
            _ => panic!("unknown field: {}", s)
        }
    }
}

impl std::ops::IndexMut<u8> for Point3d {
    fn index_mut(&mut self, s: u8) -> &mut i16 {
        match s {
            0 => &mut self.x,
            1 => &mut self.y,
            2 => &mut self.z,
            _ => panic!("unknown field: {}", s)
        }
    }
}

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
pub struct Point {
    pub x: i16,
    pub y: i16,
}

impl Point {
    pub fn dist(self) -> u16 {
        (self.x.abs() + self.y.abs()) as u16
    }

    // pub fn rad_angle(self, other: Point) -> i32 {
    pub fn rad_angle(self, other: Point) -> f64 {
        let xy_angle = self.xy_angle(other);
        // (-f64::atan2(xy_angle.x as f64, xy_angle.y as f64) * 10000.0) as i32
        f64::atan2(xy_angle.y as f64, xy_angle.x as f64)
    }

    pub fn xy_angle(self, other: Point) -> Point {
        let tangent = Point{x: other.x - self.x, y: other.y - self.y};
        let gcd = num::integer::gcd(tangent.x, tangent.y);
        Point{x: tangent.x/gcd, y: tangent.y/gcd}
    }

    pub fn step(&mut self, dir: Direction, dist: i16) -> &mut Self {
        use Direction::*;
        match dir {
            UP => self.y += dist,
            RIGHT => self.x += dist,
            DOWN => self.y -= dist,
            LEFT => self.x -= dist,
        }
        self
    }
}

impl From<(i16, i16)> for Point {
    fn from(point: (i16, i16)) -> Point {
        Point{x: point.0, y: point.1}
    }
}

impl std::ops::AddAssign for Point {
    fn add_assign(&mut self, other: Self) {
        *self = Self {
            x: self.x + other.x,
            y: self.y + other.y,
        };
    }
}

impl std::ops::Sub for Point {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

impl std::ops::Add for Point {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl std::fmt::Display for Point {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
