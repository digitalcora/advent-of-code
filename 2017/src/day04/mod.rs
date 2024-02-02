//! [🌟](https://adventofcode.com/2017/day/4) Day 4: "High-Entropy Passphrases"

mod tests;

use std::collections::HashSet;
use std::convert::identity;

/// Returns the number of valid entries in a list of "passphrases" according to a [`Rule`].
///
/// Passphrases are newline-separated, containing whitespace-separated "words" consisting of the
/// characters `a` through `z`. Phrases containing other characters are allowed and will not panic,
/// but whether they will be counted as valid is undefined.
pub fn count_valid(input: &str, rule: Rule) -> usize {
    input
        .lines()
        .filter(|line| {
            line.split_whitespace()
                .scan(HashSet::new(), |set, item| {
                    // `bytes` is fine here since inputs should only contain 'a' through 'z'
                    let mut key = item.bytes().collect::<Vec<_>>();

                    if let Rule::Anagram = rule {
                        key.sort_unstable()
                    };

                    Some(set.insert(key)) // `true` if the key was new, `false` if already existed
                })
                .all(identity)
        })
        .count()
}

/// Rules used to determine whether a "passphrase" is valid.
pub enum Rule {
    /// No word can duplicate any other (the same letters in the same order).
    Unique,
    /// No word can be an anagram of any other (the same letters in any order).
    Anagram,
}
