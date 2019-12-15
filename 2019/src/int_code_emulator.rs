#![warn(clippy::all)]

use std::collections::VecDeque;

#[derive(Debug,PartialEq,Clone,Copy)]
enum OpCode {
    Add,
    Multiply,
    Input,
    Output,
    JumpIfTrue,
    JumpIfFalse,
    LessThan,
    Equals,
    AdjustRelativeBase,
    Halt
}

impl From<i64> for OpCode {
    fn from(opcode: i64) -> OpCode {
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
            9 => AdjustRelativeBase,
            99 => Halt,
            _ => panic!("Illegal OpCode found: {}", opcode)
        }
    }
}

#[derive(Debug,PartialEq,Clone,Copy)]
enum OpMode {
    Positional, Immediate, Relative
}

impl From<i64> for OpMode {
    fn from(opmode: i64) -> OpMode {
        use OpMode::*;

        match opmode {
            0 => Positional,
            1 => Immediate,
            2 => Relative,
            _ => panic!("Illegal OpMode found: {}", opmode)
        }
    }
}

#[derive(Debug,PartialEq,Clone)]
struct OpField {
    opcode: OpCode,
    opmodes: Vec<OpMode>,
}

impl From<i64> for OpField {
    fn from(mut op: i64) -> OpField {
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

#[derive(Debug,PartialEq,Clone,Copy)]
pub enum Interrupt {
    InputRequested, InputConsumed, OutputGenerated, Halted
}

#[derive(Default, Debug, Clone)]
pub struct IntCodeEmulator {
    pub program: Vec<i64>,
    pub backup: Vec<i64>,
    pub ip: usize,
    pub rel_base: usize,
    pub last_out: Option<i64>,
    pub input: VecDeque<i64>,
    pub output: VecDeque<i64>,
}

impl From<&str> for IntCodeEmulator {
    fn from(input: &str) -> IntCodeEmulator {
        input
            .trim()
            .split(',')
            .map(|s| s.parse().unwrap_or_else(|err| panic!("{}: {}", err, s)))
            .collect::<Vec<i64>>()
            .into()
    }
}

impl From<Vec<i64>> for IntCodeEmulator {
    fn from(program: Vec<i64>) -> IntCodeEmulator {
        let backup = program.clone();
        Self{program, backup, ..Self::new()}
    }
}

impl IntCodeEmulator {
    fn get_opfield(&self) -> OpField {
        self.program[self.ip].into()
    }

    fn prepare_memory(&mut self, index: usize) {
        if index >= self.program.len() {
            self.program.resize(index+1, 0);
        }
    }

    fn get_program(&mut self, index: usize) -> i64 {
        self.prepare_memory(index);
        self.program[index]
    }

    fn get_mut_program(&mut self, index: usize) -> &mut i64 {
        self.prepare_memory(index);
        self.program.get_mut(index).unwrap() 
    }

    fn get_operand(&mut self, num: usize) -> i64 {
        let data = self.get_program(self.ip + num + 1);
        match self.get_opfield().opmodes.get(num) {
            Some(&OpMode::Immediate) => data,
            Some(&OpMode::Relative) => self.get_program((self.rel_base as i64 + data) as usize),
            Some(&OpMode::Positional) | None => self.get_program(data as usize)
        }
    }

    fn get_mut_operand(&mut self, num: usize) -> &mut i64 {
        let data = self.get_program(self.ip + num + 1);
        match self.get_opfield().opmodes.get(num) {
            Some(&OpMode::Immediate) => panic!("Tried to get mutable operand in Immediate mode"),
            Some(&OpMode::Relative) => self.get_mut_program((self.rel_base as i64 + data) as usize),
            Some(&OpMode::Positional) | None => self.get_mut_program(data as usize)
        }
    }

    pub fn new() -> Self {
        Self{program: Vec::new(), backup: Vec::new(), ip:0, rel_base: 0, last_out: None,
            input: VecDeque::new(), output: VecDeque::new() }
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

    pub fn run_to_interrupt_list(&mut self,
                                 interrupt_list: &[Interrupt]) -> Interrupt {
        loop {
            let res = self.execute();
            if let Some(res) = res {
                if interrupt_list.contains(&res) {
                    return res
                }
            }
        }
    }

    pub fn is_halted(&self) -> bool {
        self.get_opfield().opcode == OpCode::Halt
    }

    pub fn reset_program(&mut self) {
        self.program = self.backup.clone();
        self.ip = 0;
    }

    pub fn reset_all(&mut self) {
        self.reset_program();
        self.last_out = None;
        if !self.input.is_empty() {
            // println!("Input had data: {:?}", self.input);
            self.input.clear()
        }
        if !self.output.is_empty() {
            // println!("Input had data: {:?}", self.output);
            self.output.clear()
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
                if self.input.is_empty() {
                    // println!("Requested input, {:?}", self);
                    return Some(InputRequested)
                }
                let input = self.input.pop_front().unwrap();
                let dst = self.get_mut_operand(0);

                *dst = input;

                self.ip += 2;
                // println!("Consumed input, {:?}", self);
                Some(InputConsumed)
            }
            Output => {
                let src = self.get_operand(0);

                self.output.push_back(src);
                self.last_out = Some(src);

                self.ip += 2;
                // println!("Generated output, {:?}", src);
                Some(OutputGenerated)
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
            AdjustRelativeBase => {
                let rel_base_offset = self.get_operand(0);
                
                self.rel_base = (self.rel_base as i64 + rel_base_offset) as usize;

                self.ip += 2;
                // println!("AdjustRelativeBase {:?}", self);
                None
            },
            Halt => {
                Some(Halted)
            }
        }
    }
}
