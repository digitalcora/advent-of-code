#![cfg(test)]

use super::Rule::{Anagram, Unique};
use super::count_valid;

#[test]
fn examples_silver() {
    let input = concat!(
        "aa bb cc dd ee \n",  // valid
        "aa bb cc dd aa \n",  // invalid: "aa" appears twice
        "aa bb cc dd aaa \n", // valid: "aaa" is distinct from "aa"
    );

    assert_eq!(count_valid(input, Unique), 2);
    assert_eq!(count_valid("ab ba", Unique), 1); // valid, but would be invalid using `Anagram`
}

#[test]
fn examples_gold() {
    let input = concat!(
        "abcde fghij \n",              // valid
        "abcde xyz ecdab \n",          // invalid: "abcde" is an anagram of "ecdab"
        "a ab abc abd abf abj \n",     // valid
        "iiii oiii ooii oooi oooo \n", // valid
        "oiii ioii iioi iiio \n",      // invalid: every word is an anagram of every other
    );

    assert_eq!(count_valid(input, Anagram), 3);
}
