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
