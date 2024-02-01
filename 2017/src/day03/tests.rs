#![cfg(test)]

use super::{distance_to, first_value_over};

#[test]
fn examples_silver() {
    /*
    Grid locations of spiral numbers, from the puzzle description:
    17  16  15  14  13
    18   5   4   3  12
    19   6   1   2  11
    20   7   8   9  10
    21  22  23---> ...
    */
    assert_eq!(distance_to(1), 0);
    assert_eq!(distance_to(12), 3);
    assert_eq!(distance_to(23), 2);
    assert_eq!(distance_to(1024), 31);
}

#[test]
fn examples_gold() {
    /*
    Spiral memory "stress test" values, from the puzzle description:
    147  142  133  122   59
    304    5    4    2   57
    330   10    1    1   54
    351   11   23   25   26
    362  747  806--->   ...
    */
    assert_eq!(first_value_over(1), 2);
    assert_eq!(first_value_over(25), 26);
    assert_eq!(first_value_over(100), 122);
    assert_eq!(first_value_over(500), 747);
}
