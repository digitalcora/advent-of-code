//! [🌟](https://adventofcode.com/2017/day/6) Day 6: "Memory Reallocation"

mod tests;

/// Returns the length of the cycle produced by repeatedly [`reallocate`]-ing an initial state.
///
/// The input should be a whitespace-separated list of unsigned integers.
///
/// When `count_from_initial` is true, the returned length includes the number of steps taken to
/// enter the cycle from the initial state. When false, it is just the length of the cycle. As an
/// example, representing distinct states with letters:
///
/// ```
/// A -> B -> [ C -> D -> E -> C ]
/// ```
///
/// The length of this cycle is 3. Using `count_from_initial`, the returned length would be 5.
///
/// # Panics
///
/// Panics if any value cannot be parsed as [`usize`] or the input contains no values.
///
pub fn cycle_length(input: &str, count_from_initial: bool) -> usize {
    use std::collections::HashMap;
    use std::iter;

    let mut banks = input
        .split_whitespace()
        .map(|value| {
            value
                .parse::<usize>()
                .expect("block counts should be unsigned integers")
        })
        .collect::<Vec<_>>()
        .into_boxed_slice();

    iter::from_fn(move || {
        reallocate(&mut banks);
        Some(banks.clone())
    })
    .enumerate()
    .try_fold(HashMap::new(), |mut seen, (index, state)| {
        match seen.insert(state, index) {
            None => Ok(seen),
            Some(seen_at) => {
                if count_from_initial {
                    Err(index + 1)
                } else {
                    Err(index - seen_at)
                }
            }
        }
    })
    .unwrap_err()
}

/// Performs a "reallocation" routine on a slice of integers.
///
/// The routine is as follows: Suppose each slice index contains a number of "blocks" equal to its
/// value. Blocks cannot be created or destroyed, only moved. Find the index with the most blocks
/// (ties broken in favor of the lowest index), then remove all of its blocks and begin traversing
/// the subsequent indices (with wraparound), adding one of the blocks to each, until we run out.
///
/// # Panics
///
/// Panics if the slice is empty.
///
pub fn reallocate(banks: &mut Box<[usize]>) {
    let mut index = banks
        .iter()
        .enumerate()
        // Reverse the comparison and use `min_by` instead of `max_by`, since the former gives
        // the behavior we want when there are multiple items of the same minimum/maximum value
        // (choosing the first one).
        .min_by(|(_, a), (_, b)| b.cmp(a))
        .map(|(index, _)| index)
        .expect("slice should not be empty");

    let mut blocks = banks[index];
    banks[index] = 0;

    while blocks > 0 {
        index += 1;
        if index == banks.len() {
            index = 0;
        }

        blocks -= 1;
        banks[index] += 1;
    }
}
