//! [🌟](https://adventofcode.com/2017/day/1) Day 1: "Inverse Captcha"

mod tests;

/// Returns the sum of "matching" digits in a string of decimal digits.
///
/// Whether a digit has a match and contributes to the sum is determined by [`How`].
///
/// # Panics
///
/// May panic when the input contains bytes other than `b'0'` through `b'9'`.
///
pub fn solve(input: &str, how: How) -> usize {
    // Since '0' through '9' are encoded sequentially (and as one byte) in UTF-8, we can iterate
    // over the raw bytes of the input slice, subtracting the byte value of '0' to get a numeric
    // value for a character. The performance advantage over `chars` and `to_digit` is irrelevant
    // at the scale of this puzzle, but it does have a pleasing code-golf factor.

    let bytes = input.bytes();

    let skip_n = match how {
        How::Next => 1,
        How::Opposite => bytes.len() / 2,
    };

    let matches = bytes.clone().cycle().skip(skip_n);

    bytes
        .zip(matches)
        .map(|(byte, other)| {
            if byte == other {
                (byte - b'0') as usize
            } else {
                0
            }
        })
        .sum()
}

/// Indicates how [`solve`] should look for matching digits.
///
/// Iff the digit at this position is the same as the one being checked, it matches. Note the list
/// of digits is treated as circular: the next digit after the last one is the first one.
pub enum How {
    /// The digit following the current one.
    Next,
    /// The digit opposite the current one ("halfway around" the circular list). Assumes there are
    /// an even number of digits.
    Opposite,
}
