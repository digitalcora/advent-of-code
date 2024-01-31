//! [🌟](https://adventofcode.com/2017/day/2) Day 2: "Corruption Checksum"

mod tests;

/// Calculates a "checksum" for a "spreadsheet" of numeric values.
///
/// The input should be newline-separated rows, containing whitespace-separated non-negative
/// integers. The "checksum" is the sum of the differences between the largest and smallest values
/// in each row.
///
/// # Panics
///
/// Panics if any cell cannot be parsed as [`u32`].
///
pub fn checksum(input: &str) -> u32 {
    const MAXMIN: [u32; 2] = [u32::MAX, u32::MIN];

    input
        .lines()
        .map(|line| {
            let minmax = line.split_whitespace().fold(MAXMIN, |[min, max], cell| {
                let num = cell.parse::<u32>().expect("cell values should be u32");
                [num.min(min), num.max(max)]
            });

            match minmax {
                minmax if minmax == MAXMIN => 0, // row was empty
                [min, max] => max - min,
            }
        })
        .sum()
}

/// Like [`checksum`] but determines row values using a division-based method.
///
/// The value for each row is determined by finding a pair of values that divide evenly, and using
/// the result of this division. As with [`checksum`], the return value is the sum of these values.
/// If there are multiple pairs that divide evenly, one is chosen arbitrarily. (AoC puzzle inputs
/// are guaranteed to contain exactly one such pair.)
///
/// # Panics
///
/// Panics if any cell cannot be parsed as [`u32`], or if any row does not contain a pair of values
/// that divide evenly.
///
pub fn divsum(input: &str) -> u32 {
    input
        .lines()
        .map(|line| {
            let nums = line
                .split_whitespace()
                .map(|cell| cell.parse::<u32>().expect("cell values should be u32"))
                .collect::<Vec<_>>();

            nums.iter()
                .enumerate()
                .flat_map(|(i, num)| {
                    nums.iter()
                        .skip(i + 1)
                        .map(move |other| [num.max(other), num.min(other)])
                })
                .filter_map(|[a, b]| if a % b == 0 { Some(a / b) } else { None })
                .next()
                .expect("rows should have at least one pair of cells that divide evenly")
        })
        .sum()
}
