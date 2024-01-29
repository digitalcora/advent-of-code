#![cfg(test)]

use super::solve;
use super::How::{Next, Opposite};

#[test]
fn examples_silver() {
    assert_eq!(solve("1122", Next), 3);
    assert_eq!(solve("1111", Next), 4);
    assert_eq!(solve("1234", Next), 0);
    assert_eq!(solve("91212129", Next), 9);
}

#[test]
fn examples_gold() {
    assert_eq!(solve("1212", Opposite), 6);
    assert_eq!(solve("1221", Opposite), 0);
    assert_eq!(solve("123425", Opposite), 4);
    assert_eq!(solve("123123", Opposite), 12);
    assert_eq!(solve("12131415", Opposite), 4);
}
