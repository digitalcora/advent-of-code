#![cfg(test)]

use super::cycle_length;

#[test]
fn examples_silver() {
    assert_eq!(cycle_length("0 2 7 0", true), 5);

    // Test that the first instance of a duplicate maximum value is chosen; if the second instance
    // were chosen here, the result would be different (6 instead of 12)
    assert_eq!(cycle_length("2 5 9 9", true), 12);
}

#[test]
fn examples_gold() {
    assert_eq!(cycle_length("0 2 7 0", false), 4);
    assert_eq!(cycle_length("2 5 9 9", false), 8);
}
