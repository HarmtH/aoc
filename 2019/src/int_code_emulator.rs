#![warn(clippy::all)]

#[derive(Debug,PartialEq,Clone)]
enum OpCode {
    Add,
    Multiply,
    Input,
    Output,
    JumpIfTrue,
    JumpIfFalse,
    LessThan,
    Equals,
    Halt
}

impl From<i32> for OpCode {
    fn from(opcode: i32) -> OpCode {
        use OpCode::*;

        match opcode {
            1 => Add,
            2 => Multiply,
            3 => Input,
            4 => Output,
            5 => JumpIfTrue,
            6 => JumpIfFalse,
            7 => LessThan,
            8 => Equals,
            99 => Halt,
            _ => panic!("Illegal OpCode found: {}", opcode)
        }
    }
}

#[derive(Debug,PartialEq,Clone)]
enum OpMode {
    Positional, Immediate
}

impl From<i32> for OpMode {
    fn from(opmode: i32) -> OpMode {
        use OpMode::*;

        match opmode {
            0 => Positional,
            1 => Immediate,
            _ => panic!("Illegal OpMode found: {}", opmode)
        }
    }
}

#[derive(Debug,PartialEq,Clone)]
struct OpField {
    opcode: OpCode,
    opmodes: Vec<OpMode>,
}

impl From<i32> for OpField {
    fn from(mut op: i32) -> OpField {
        let opcode: OpCode = (op % 100).into();
        op /= 100;
        let mut opmodes = Vec::new();
        while op != 0 {
            opmodes.push((op % 10).into());
            op /= 10;
        }
        OpField{opcode, opmodes}
    }
}

#[derive(Debug,PartialEq,Clone)]
pub enum Interrupt {
    InputConsumed, OutputSet, Halted
}

#[derive(Debug)]
pub struct IntCodeEmulator {
    pub program: Vec<i32>,
    pub ip: usize,
    pub input: Vec<i32>,
    pub output: Vec<i32>,
}

impl From<&str> for IntCodeEmulator {
    fn from(input: &str) -> IntCodeEmulator {
        input
            .trim()
            .split(',')
            .map(|s| s.parse().unwrap_or_else(|err| panic!("{}: {}", err, s)))
            .collect::<Vec<i32>>()
            .into()
    }
}

impl From<Vec<i32>> for IntCodeEmulator {
    fn from(program: Vec<i32>) -> IntCodeEmulator {
        Self{program, ip: 0, input: Vec::new(), output: Vec::new()}
    }
}

impl IntCodeEmulator {
    fn get_opfield(&self) -> OpField {
        self.program[self.ip].into()
    }

    fn get_mut_operand(&mut self, num: usize) -> &mut i32 {
        let pos = self.program[self.ip + num + 1] as usize;
        self.program.get_mut(pos).unwrap() 
    }

    fn get_operand(&self, num: usize) -> i32 {
        let data = self.program[self.ip + num + 1];
        match self.get_opfield().opmodes.get(num) {
            Some(&OpMode::Immediate) => data,
            _ => self.program[data as usize]
        }
    }

    pub fn run_to_halt(&mut self) {
        loop {
            let res = self.execute();
            if res == Some(Interrupt::Halted) { break }
        }
    }

    pub fn run_to_interrupt(&mut self) -> Interrupt {
        loop {
            let res = self.execute();
            if let Some(res) = res { return res }
        }
    }

    fn execute(&mut self) -> Option<Interrupt> {
        use OpCode::*;
        use Interrupt::*;

        match self.get_opfield().opcode {
            Add => {
                let term1 = self.get_operand(0);
                let term2 = self.get_operand(1);
                let dst = self.get_mut_operand(2);

                *dst = term1 + term2;

                self.ip += 4;
                // println!("Added, {:?}", self);
                None
            },
            Multiply => {
                let factor1 = self.get_operand(0);
                let factor2 = self.get_operand(1);
                let dst = self.get_mut_operand(2);

                *dst = factor1 * factor2;

                self.ip += 4;
                // println!("Multiplied {:?}", self);
                None
            },
            Input => {
                let input = self.input.pop()
                    .expect("Input requsted with empty input vector");
                let dst = self.get_mut_operand(2);

                *dst = input;

                self.ip += 2;
                // println!("Stored input, {:?}", self);
                Some(InputConsumed)
            }
            Output => {
                let src = self.get_operand(0);

                self.output.push(src);

                self.ip += 2;
                // println!("Pushed output, {:?}", src);
                Some(OutputSet)
            }
            JumpIfTrue => {
                let cond = self.get_operand(0);
                let target = self.get_operand(1);

                if cond != 0 {
                    self.ip = target as usize;
                } else {
                    self.ip += 3;
                }

                // println!("JumpIfTrue {:?}", self);
                None
            },
            JumpIfFalse => {
                let cond = self.get_operand(0);
                let target = self.get_operand(1);

                if cond == 0 {
                    self.ip = target as usize;
                } else {
                    self.ip += 3;
                }

                // println!("JumpIfFalse {:?}", self);
                None
            },
            LessThan => {
                let cond1 = self.get_operand(0);
                let cond2 = self.get_operand(1);
                let dst = self.get_mut_operand(2);

                *dst = if cond1 < cond2 { 1 } else { 0 };

                self.ip += 4;
                // println!("LessThan {:?}", self);
                None
            },
            Equals => {
                let cond1 = self.get_operand(0);
                let cond2 = self.get_operand(1);
                let dst = self.get_mut_operand(2);

                *dst = if cond1 == cond2 { 1 } else { 0 };

                self.ip += 4;
                // println!("Equals {:?}", self);
                None
            },
            Halt => Some(Halted),
        }
    }
}
