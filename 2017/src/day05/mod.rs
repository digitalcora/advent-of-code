//! [🌟](https://adventofcode.com/2017/day/5) Day 5: "A Maze of Twisty Trampolines, All Alike"

mod tests;

/// Returns how many steps a [`Machine`] with the given program and [`Rule`] will take to halt.
///
/// The program should be a whitespace-separated list of instructions, which are signed integers.
///
/// # Panics
///
/// Panics if any instruction cannot be parsed as [`isize`].
///
pub fn steps_to_halt(input: &str, rule: Rule) -> usize {
    let program = input
        .split_whitespace()
        .map(|value| value.parse::<isize>().expect("offsets should be integers"))
        .collect::<Vec<_>>();

    let mut machine = Machine::new(program.into(), rule);
    machine.run()
}

/// Controls what happens to a [`Machine`] instruction after it is executed.
pub enum Rule {
    /// The value is always increased by 1.
    Always,
    /// The value is increased by 1 if it is less than 3, else it is decreased by 1.
    LessThanThree,
}

/// Represents a very simple "CPU" with only one instruction type.
pub struct Machine {
    ip: isize, // instruction pointer
    program: Box<[isize]>,
    rule: Rule,
}

impl Machine {
    /// Initializes a machine.
    ///
    /// Since there is only one instruction type (a relative jump), the "program" is an array of
    /// jump offsets. The instruction pointer begins at the first instruction (index 0).
    pub fn new(program: Box<[isize]>, rule: Rule) -> Self {
        Self {
            ip: 0,
            program,
            rule,
        }
    }

    /// Executes a single instruction.
    ///
    /// The instruction pointer is advanced by the current instruction's value, which is then
    /// modified according to the machine's [`Rule`].
    ///
    /// Returns `false` iff the machine is halted (the instruction pointer is outside the bounds of
    /// the program). In this case `self` is not modified.
    pub fn step(&mut self) -> bool {
        self.ip.try_into().map_or(false, |uip: usize| {
            self.program.get_mut(uip).map_or(false, |value| {
                self.ip += *value;

                *value += match self.rule {
                    Rule::Always => 1,
                    Rule::LessThanThree => {
                        if *value < 3 {
                            1
                        } else {
                            -1
                        }
                    }
                };

                true
            })
        })
    }

    /// Runs the machine until it halts, returning the number of instructions executed.
    pub fn run(&mut self) -> usize {
        let mut steps = 0;

        while self.step() {
            steps += 1;
        }

        steps
    }
}
