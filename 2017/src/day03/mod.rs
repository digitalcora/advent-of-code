//! [🌟](https://adventofcode.com/2017/day/3) Day 3: "Spiral Memory"

mod tests;

use std::collections::HashMap;

/// Returns the Manhattan distance from the origin to the `n`th location in the [`Spiral`] sequence.
///
/// # Panics
///
/// Panics or underflows if `n == 0`. The origin is considered the `1`st location, not the `0`th.
///
pub fn distance_to(n: usize) -> usize {
    let [x, y] = Spiral::new().nth(n - 1).unwrap();
    x.unsigned_abs() + y.unsigned_abs()
}

/// Returns the first value greater than a given threshold in the spiral "stress test" pattern.
///
/// The "stress test" involves an infinite 2D grid of integers, all initially `0` except for a `1`
/// at the origin. Then for each location in the [`Spiral`] sequence (skipping the origin), the
/// value at that location is set to the sum of the 8 adjacent values. This process continues until
/// it produces a value greater than `threshold`, which is returned.
pub fn first_value_over(threshold: usize) -> usize {
    const NEIGHBORS: [[isize; 2]; 8] = [
        [-1, -1],
        [0, -1],
        [1, -1],
        [-1, 0],
        [1, 0],
        [-1, 1],
        [0, 1],
        [1, 1],
    ];

    let mut grid = HashMap::new();
    grid.insert([0, 0], 1);

    Spiral::new()
        .skip(1) // "base case" already inserted above
        .scan(grid, |grid, [x, y]| {
            let value = NEIGHBORS
                .iter()
                .map(|[dx, dy]| grid.get(&[x + dx, y + dy]).unwrap_or(&0))
                .sum();

            let result = grid.insert([x, y], value);
            assert!(result.is_none(), "value was already in grid");
            Some(value)
        })
        .find(|&stored| stored > threshold)
        .unwrap()
}

/// Iterator which endlessly produces coordinates of a square spiral pattern on a 2D grid.
///
/// The first two values are `[0, 0]` and `[1, 0]`. The coordinates then trace out squares of
/// increasing size around the origin, staying as close to it as possible while never revisiting a
/// location. If positive X is "right" and positive Y is "down", the pattern goes clockwise around
/// the origin and the final coordinate of each square is its upper-right corner; the next step is
/// to the right, and the next square begins by moving down.
///
/// # Examples
///
/// ```
/// # use advent::day03::Spiral;
/// assert_eq!(
///     Spiral::new().take(10).collect::<Vec<_>>(),
///     vec![[0, 0], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1], [2, -1]]
/// )
/// ```
#[derive(Default)]
pub struct Spiral {
    bound: isize, // `coords` absolute values should not exceed this until done with current square
    coords: [isize; 2],
}

impl Spiral {
    pub fn new() -> Self {
        Default::default()
    }
}

impl Iterator for Spiral {
    type Item = [isize; 2];

    fn next(&mut self) -> Option<Self::Item> {
        let item = Some(self.coords);

        // on north side heading east; allowed to step outside the current square, expanding it
        if self.coords[1] == -self.bound && self.coords[0] <= self.bound {
            self.coords[0] += 1;

            if self.coords[0] > self.bound {
                self.bound += 1
            }
        // on east side heading south
        } else if self.coords[0] == self.bound && self.coords[1] < self.bound {
            self.coords[1] += 1
        // on south side heading west
        } else if self.coords[1] == self.bound && self.coords[0] > -self.bound {
            self.coords[0] -= 1
        // on west side heading north
        } else if self.coords[0] == -self.bound && self.coords[1] > -self.bound {
            self.coords[1] -= 1
        };

        item
    }
}
