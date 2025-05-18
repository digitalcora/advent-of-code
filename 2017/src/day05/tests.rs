#![cfg(test)]

use super::Rule::{Always, LessThanThree};
use super::steps_to_halt;

#[test]
fn examples_silver() {
    assert_eq!(steps_to_halt("0 3 0 1 -3", Always), 5);
}

#[test]
fn examples_gold() {
    assert_eq!(steps_to_halt("0 3 0 1 -3", LessThanThree), 10);
}
