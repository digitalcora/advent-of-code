//! [🌟](https://adventofcode.com/2017/day/5) Day 5: "A Maze of Twisty Trampolines, All Alike"

mod tests;

use std::iter::FusedIterator;

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

    let machine = Machine::new(program.into(), rule);
    machine.count()
}

/// Controls what happens to a [`Machine`] instruction after it is executed.
pub enum Rule {
    /// The value is always increased by 1.
    Always,
    /// The value is increased by 1 if it is less than 3, else it is decreased by 1.
    LessThanThree,
}

/// Iterator representing a very simple "CPU" with only one instruction type.
///
/// Advancing the iterator either executes the next instruction, or halts if the instruction pointer
/// is outside the bounds of the program. Since the machine does not expose any state other than
/// whether it has halted, the values produced are simply `()`.
pub struct Machine {
    ip: isize, // instruction pointer
    program: Box<[isize]>,
    rule: Rule,
}

impl Machine {
    /// Initializes a machine.
    ///
    /// Since there is only one instruction type, a relative jump, the "program" is an array of jump
    /// offsets. The instruction pointer begins at the first instruction (index 0).
    ///
    /// The [`Rule`] controls how an instruction is updated after being executed.
    pub fn new(program: Box<[isize]>, rule: Rule) -> Self {
        Self {
            ip: 0,
            program,
            rule,
        }
    }
}

impl Iterator for Machine {
    type Item = ();

    fn next(&mut self) -> Option<Self::Item> {
        self.ip.try_into().map_or(None, |uip: usize| {
            self.program.get_mut(uip).map_or(None, |value| {
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

                Some(())
            })
        })
    }
}

impl FusedIterator for Machine {}
